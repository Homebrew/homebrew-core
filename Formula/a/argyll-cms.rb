class ArgyllCms < Formula
  desc "ICC compatible color management system"
  homepage "https://www.argyllcms.com/"
  url "https://www.argyllcms.com/Argyll_V3.5.0_src.zip"
  sha256 "f8576ce5589fd15620abb73ff049ea31f55ddbd1bba6d1ffa87452658e7bc85f"
  license "AGPL-3.0-only"

  livecheck do
    url "https://www.argyllcms.com/downloadsrc.html"
    regex(/href=.*?Argyll[._-]v?(\d+(?:\.\d+)+)[._-]src\.zip/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_golden_gate: "585de1b56d00de6d7ab345d8d590cd415d70e3c5f5a847ab37196f074b1b5c22"
    sha256 cellar: :any, arm64_tahoe:       "3f2bd767813d16e34fcb2eef9c377a21788cb67a0bd293f505cbfbb7b6be01c1"
    sha256 cellar: :any, arm64_sequoia:     "85b0ae0e0e6d6591900bf6085241b854b4d8c55d28685cc4be783d42c413633b"
    sha256               arm64_linux:       "c00d9e488f123acea9ac11e5bcdf23d21833a9432d829e25e389087837cacba8"
    sha256               x86_64_linux:      "5c6c560545149c627bb8b069668ed4769ea81c2dc1d309c5046b32dd50112842"
  end

  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openssl@4"

  on_linux do
    depends_on "libx11"
    depends_on "libxext"
    depends_on "libxinerama"
    depends_on "libxrandr"
    depends_on "libxscrnsaver"
    depends_on "libxxf86vm"
    depends_on "xorgproto"
    depends_on "zlib-ng-compat"
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
      file "Patches/jam/2.6.1.patch"
      type :unofficial
    end
  end

  deny_network_access!

  def install
    resource("jam").stage do
      system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}", "LOCATE_TARGET=bin"
      (buildpath/"bin").install "bin/jam"
    end

    # Remove bundled libraries to prevent fallback
    %w[jpeg png tiff zlib].each { |l| rm_r(buildpath/l) }

    inreplace "Jamtop" do |s|
      openssl = "openssl@4"
      libname = shared_library("lib$(lcase)")
      usr = "#{MacOS.sdk_path if OS.mac?}/usr"

      # These two inreplaces make sure all Homebrew and SDK libraries can be found by the Jamfile
      s.gsub! "[ GLOB /usr/include$(subd) : $(lcase).h $(lcase)lib.h ]",
              "[ GLOB #{formula_opt_include(openssl)}$(subd) : $(lcase).h $(lcase)lib.h ] || " \
              "[ GLOB #{HOMEBREW_PREFIX}/include$(subd) : $(lcase).h $(lcase)lib.h ] || " \
              "[ GLOB #{usr}/include$(subd) : $(lcase).h $(lcase)lib.h ]"
      s.gsub! "[ GLOB /usr/lib : lib$(lcase).so ]",
              "[ GLOB #{formula_opt_lib(openssl)} : #{libname} ] || " \
              "[ GLOB #{HOMEBREW_PREFIX}/lib : #{libname} ] || " \
              "[ GLOB #{usr}/lib : #{libname} lib$(lcase).tbd ]"

      # These two inreplaces make sure the X11 headers can be found on Linux.
      s.gsub! "/usr/X11R6/include", HOMEBREW_PREFIX/"include"
      s.gsub! "/usr/X11R6/lib", HOMEBREW_PREFIX/"lib"
    end
    (buildpath/"Jamtop").append_lines <<~JAM
      CCFLAGS += -fno-strict-aliasing ;
    JAM

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
