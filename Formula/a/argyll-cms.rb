class ArgyllCms < Formula
  desc "ICC compatible color management system"
  homepage "https://www.argyllcms.com/"
  url "https://www.argyllcms.com/Argyll_V3.1.0_src.zip"
  sha256 "4fdd5a1d7bc6dde79a54e350ec9374f6ef00b53903ee0d184cdfa4a11f0ecdcb"
  license "AGPL-3.0-only"

  livecheck do
    url "https://www.argyllcms.com/downloadsrc.html"
    regex(/href=.*?Argyll[._-]v?(\d+(?:\.\d+)+)[._-]src\.zip/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4c387a6551506759bc97e05f1a8210c9daa6067766a928aec40f6f53f98cece4"
    sha256 cellar: :any,                 arm64_ventura:  "f278516489fd047cf57e844c11b865d174dbca8d0fd3f8933d043a4ec8fcc9b5"
    sha256 cellar: :any,                 arm64_monterey: "5291dc8cc86cead75c15e6911d38953c384bea72b2f73ef3ebc910b8f262bdfe"
    sha256 cellar: :any,                 sonoma:         "a882ec21e0a632a75ff2ba7de2599811c18bf8418db0838c45c820392f999e51"
    sha256 cellar: :any,                 ventura:        "1a8e2ff8c685c60e4bcadcc221453fe3d5dfdf7fc0394afcf99d628035139a5a"
    sha256 cellar: :any,                 monterey:       "4b467bb519a71f349989b2ad225704703a6dd4ae8525624ac4f562f3ed2c4262"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c071c90cae813ef853d2b3d17fa25b4f846b2a6079392b0f7270e194d135c51e"
  end

  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "libx11"
    depends_on "libxinerama"
    depends_on "libxrandr"
    depends_on "libxscrnsaver"
    depends_on "libxxf86vm"
    depends_on "xorgproto"
  end

  conflicts_with "num-utils", because: "both install `average` binaries"

  resource "jam" do
    # The "Jam Documentation" page has a banner stating:
    # "Perforce is no longer actively contributing to the Jam Open Source project.
    # The last Perforce release of Jam was version 2.6 in August of 2014. We will
    # keep the Perforce-controlled links and information posted here available
    # until further notice."

    # The argyll-cms maintainer told us that they want to keep jam as a build system
    # even if it is not maintained anymore
    # https://www.freelists.org/post/argyllcms/Status-of-Jam-build,1
    # Vendoring jam will allow to get rid of our jam formula
    url "https://swarm.workshop.perforce.com/downloads/guest/perforce_software/jam/jam-2.6.1.zip"
    sha256 "72ea48500ad3d61877f7212aa3d673eab2db28d77b874c5a0b9f88decf41cb73"

    # * Ensure <unistd.h> is included on macOS, fixing the following error:
    #   `make1.c:392:8: error: call to undeclared function 'unlink'`.
    # * Fix a typo that leads to an undeclared function error:
    #   `parse.c:102:20: error: call to undeclared function 'yylineno'`
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/42252ab3d438f7ada66e83b92bb51a9178d3df10/jam/2.6.1-undeclared_functions.diff"
      sha256 "d567cbaf3914f38bb8c5017ff01cc40fe85970c34d3ad84dbeda8c893518ffae"
    end
  end

  # Fixes a missing header, which is an error by default on arm64 but not x86_64
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/f6ede0dff06c2d9e3383416dc57c5157704b6f3a/argyll-cms/unistd_import.diff"
    sha256 "5ce1e66daf86bcd43a0d2a14181b5e04574757bcbf21c5f27b1f1d22f82a8a6e"
  end

  def install
    resource("jam").stage do
      system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}", "LOCATE_TARGET=bin"
      libexec.install "bin/jam"
    end

    # Remove bundled libraries to prevent fallback
    %w[jpeg png tiff zlib].each { |l| (buildpath/l).rmtree }

    inreplace "Jamtop" do |s|
      openssl = Formula["openssl@3"]
      libname = shared_library("lib$(lcase)")
      usr = if OS.mac?
        "#{MacOS.sdk_path_if_needed}/usr"
      else
        "/usr"
      end

      # These two inreplaces make sure all Homebrew and SDK libraries can be found by the Jamfile
      s.gsub! "[ GLOB /usr/include$(subd) : $(lcase).h $(lcase)lib.h ]",
              "[ GLOB #{openssl.opt_include}$(subd) : $(lcase).h $(lcase)lib.h ] || " \
              "[ GLOB #{HOMEBREW_PREFIX}/include$(subd) : $(lcase).h $(lcase)lib.h ] || " \
              "[ GLOB #{usr}/include$(subd) : $(lcase).h $(lcase)lib.h ]"
      s.gsub! "[ GLOB /usr/lib : lib$(lcase).so ]",
              "[ GLOB #{openssl.opt_lib} : #{libname} ] || " \
              "[ GLOB #{HOMEBREW_PREFIX}/lib : #{libname} ] || " \
              "[ GLOB #{usr}/lib : #{libname} lib$(lcase).tbd ]"

      # These two inreplaces make sure the X11 headers can be found on Linux.
      s.gsub! "/usr/X11R6/include", HOMEBREW_PREFIX/"include"
      s.gsub! "/usr/X11R6/lib", HOMEBREW_PREFIX/"lib"
    end

    ENV["NUMBER_OF_PROCESSORS"] = ENV.make_jobs.to_s
    inreplace "makeall.sh", "jam", libexec/"jam"
    inreplace "makeinstall.sh", "jam", libexec/"jam"
    system "sh", "makeall.sh"
    system "./makeinstall.sh"
    rm "bin/License.txt"
    prefix.install "bin", "ref", "doc"

    rm libexec/"jam"
  end

  test do
    system bin/"targen", "-d", "0", "test.ti1"
    system bin/"printtarg", testpath/"test.ti1"
    %w[test.ti1.ps test.ti1.ti1 test.ti1.ti2].each do |f|
      assert_predicate testpath/f, :exist?
    end

    # Skip this part of the test on Linux because it hangs due to lack of a display.
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match "Calibrate a Display", shell_output("#{bin}/dispcal 2>&1", 1)
  end
end
