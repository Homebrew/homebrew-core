class ArgyllCms < Formula
  desc "ICC compatible color management system"
  homepage "https://www.argyllcms.com/"
  url "https://www.argyllcms.com/Argyll_V3.4.0_src.zip"
  sha256 "946b096ae25d67819626f6992e9f7fb1c65f512ac9484697771b2cda5a16d3b3"
  license "AGPL-3.0-only"

  livecheck do
    url "https://www.argyllcms.com/downloadsrc.html"
    regex(/href=.*?Argyll[._-]v?(\d+(?:\.\d+)+)[._-]src\.zip/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "90871b2934f470e24ce78c6e9a34b8188decc91975e5d1d436fe39ae3d62970b"
    sha256 cellar: :any, arm64_sonoma:  "2677c3c242402f974b080eaf48dd09e669e6ada23cf1e2eb93ef525d1aa89191"
    sha256 cellar: :any, arm64_ventura: "f30b5cc9a3a20da4ac90ce7a79f7d2472457e4e547509b067a7082858acff992"
    sha256 cellar: :any, sonoma:        "4ad8fe91dfe383094cde8fe14b4b50082a32506dbb5bb51547f0fdb90d959a2f"
    sha256 cellar: :any, ventura:       "de70a32366f4f4fe9f7dc2e93756e27d40808fcb4d2cb1268abb91c29314dfa1"
    sha256               arm64_linux:   "cf6ffaa5117c417cc0b31ede9f843d7748192ad41198f2d93d0198ebf4a9e377"
    sha256               x86_64_linux:  "0632447f07e2e431a1319aeaaf109c8bdc0f48ca0d3f141416ace5f6d5097d4c"
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
    rm "bin/com.argyllcms.metainfo.xml"
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
