class ArgyllCms < Formula
  desc "ICC compatible color management system"
  homepage "https://www.argyllcms.com/"
  url "https://www.argyllcms.com/Argyll_V3.4.1_src.zip"
  sha256 "41ad51e02a3ec6981611be473221a3877fd359d3c1fa2172b4265dbe55f8b746"
  license "AGPL-3.0-only"

  livecheck do
    url "https://www.argyllcms.com/downloadsrc.html"
    regex(/href=.*?Argyll[._-]v?(\d+(?:\.\d+)+)[._-]src\.zip/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ae9c7d99adca2b6382b1fbd34f36db5b5fca42d18d362408b8095acb10cb04e4"
    sha256 cellar: :any, arm64_sequoia: "f16dded9bf615eb33b11a9533524d2020498e7aab4766eb7c4de993e83cc8719"
    sha256 cellar: :any, arm64_sonoma:  "0e15bf67bbbf98bf5cc480af3a90a0ac900616fd96dccf9cb1a53493e9ea6a0d"
    sha256 cellar: :any, arm64_ventura: "b39ba95474701b963dadfddeca4bea00b037bb1baa766382e1108a879c50f84b"
    sha256 cellar: :any, sonoma:        "52ec759d47c3d4925f111e492be5f52417bca86187e1aaf212b9a834729ccdb5"
    sha256 cellar: :any, ventura:       "f8bc593f16e7c88c7c9ff5b852269223166f40d2de1dc68ea8957d0bc02c21d9"
    sha256               arm64_linux:   "6e40aab9550ed5d4df52fb6bd054e352d0f6fdbccb5d02f412b2294c40f49332"
    sha256               x86_64_linux:  "3d62059d60adbb6c0483ff303014de71bd9b2d4dd29b67d1b5122e8f5c817a72"
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
      url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/jam/2.6.1.patch"
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
