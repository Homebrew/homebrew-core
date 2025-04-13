class ArgyllCms < Formula
  desc "ICC compatible color management system"
  homepage "https://www.argyllcms.com/"
  url "https://www.argyllcms.com/Argyll_V3.3.0_src.zip"
  sha256 "69db1c9ef66f8cacbbbab4ed9910147de6100c3afd17a0a8c12e6525b778e8ce"
  license "AGPL-3.0-only"

  livecheck do
    url "https://www.argyllcms.com/downloadsrc.html"
    regex(/href=.*?Argyll[._-]v?(\d+(?:\.\d+)+)[._-]src\.zip/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "c6eaa8f9f20129203c4ad4f8e536c0f8046a8c1f8376ecc2eb3e5ac4cd230b21"
    sha256 cellar: :any,                 arm64_sonoma:  "6144869b77d490945df7d2e207baa71dbb7034a3dc914f00a71733f00956e58d"
    sha256 cellar: :any,                 arm64_ventura: "c2a6ef0092b8b2ace04571ded3efee5e4fd39bdef7aaa2762deb1651de3389c0"
    sha256 cellar: :any,                 sonoma:        "6836561552f12daecbe3f808ac50e58588d402036c242d0b5b21ac7620773118"
    sha256 cellar: :any,                 ventura:       "e85f428eeb690ac25daf20b991f3b9c3fbeb3f53cc276fb2b7a031cff835c5ac"
    sha256                               arm64_linux:   "03a6e4bd49c1a92adf66999ac471f5c014cab3cf4792c43e57832115f4a5487a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76bf52c81646502007e8bb73fb1d247c0789d2d2aad4ffff41023f060f000fb1"
  end

  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "libx11"
    depends_on "libxext"
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
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/cf70f015e7398796660da57212ff0ab90c609acf/jam/2.6.1.patch"
      sha256 "1850cf53c4db0e05978d52b90763b519c00fa4f2fbd6fc2753200e49943821ec"
    end
  end

  def install
    resource("jam").stage do
      system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}", "LOCATE_TARGET=bin"
      (buildpath/"bin").install "bin/jam"
    end

    # Remove bundled libraries to prevent fallback
    %w[jpeg png tiff zlib].each { |l| rm_r(buildpath/l) }

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

    inreplace "makeall.sh", "jam", buildpath/"bin/jam"
    inreplace "makeinstall.sh", "jam", buildpath/"bin/jam"
    system "sh", "makeall.sh"
    system "./makeinstall.sh"
    rm "bin/License.txt"
    prefix.install "bin", "ref", "doc"
  end

  test do
    system bin/"targen", "-d", "0", "test.ti1"
    system bin/"printtarg", testpath/"test.ti1"

    %w[test.ti1.ps test.ti1.ti1 test.ti1.ti2].each do |f|
      assert_path_exists testpath/f
    end

    # Skip this part of the test on Linux because it hangs due to lack of a display.
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match "Calibrate a Display", shell_output("#{bin}/dispcal 2>&1", 1)
  end
end
