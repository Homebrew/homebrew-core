class Nss < Formula
  desc "Libraries for security-enabled client and server applications"
  homepage "https://developer.mozilla.org/docs/NSS"
  url "https://ftp.mozilla.org/pub/security/nss/releases/NSS_3_60_RTM/src/nss-3.60.tar.gz"
  sha256 "84abd5575ab874c53ae511bd461e5d0868d1a1b384ee40753154cdd1d590fe3d"
  license "MPL-2.0"

  livecheck do
    url "https://ftp.mozilla.org/pub/security/nss/releases/"
    regex(%r{href=.*?NSS[._-]v?(\d+(?:[._]\d+)+)[._-]RTM/?["' >]}i)
  end

  bottle do
    cellar :any
    sha256 "cf1a0f081a61bcb62dd686814b7e3fb648928e446a150e4f657edda17ef65e10" => :big_sur
    sha256 "068e8340dfe4243e3dd2a7b6df006f3f4cdc7ffad6a7f3668ed4d8e25ceb1a93" => :catalina
    sha256 "47468eb1600e4f7f8f94759e54cad4ca33f5e702eb155a9781190a0980673346" => :mojave
    sha256 "92a0f9ec54b581d6cd1e30fa51db545463f83e53f5fa2ea4a8ab14797cab3e3e" => :high_sierra
  end

  depends_on "nspr"

  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  conflicts_with "resty", because: "both install `pp` binaries"
  conflicts_with "googletest", because: "both install `libgtest.a`"

  def install
    ENV.deparallelize
    cd "nss"

    args = %W[
      BUILD_OPT=1
      NSS_ALLOW_SSLKEYLOGFILE=1
      NSS_USE_SYSTEM_SQLITE=1
      NSPR_INCLUDE_DIR=#{Formula["nspr"].opt_include}/nspr
      NSPR_LIB_DIR=#{Formula["nspr"].opt_lib}
      USE_64=1
    ]

    # Remove the broken (for anyone but Firefox) install_name
    inreplace "coreconf/Darwin.mk", "-install_name @executable_path", "-install_name #{lib}"
    inreplace "lib/freebl/config.mk", "@executable_path", lib

    system "make", "all", *args

    # We need to use cp here because all files get cross-linked into the dist
    # hierarchy, and Homebrew's Pathname.install moves the symlink into the keg
    # rather than copying the referenced file.
    cd "../dist"
    bin.mkpath
    Dir.glob("Darwin*/bin/*") do |file|
      cp file, bin unless file.include? ".dylib"
    end

    include_target = include + "nss"
    include_target.mkpath
    Dir.glob("public/{dbm,nss}/*") { |file| cp file, include_target }

    lib.mkpath
    libexec.mkpath
    Dir.glob("Darwin*/lib/*") do |file|
      if file.include? ".chk"
        cp file, libexec
      else
        cp file, lib
      end
    end
    # resolves conflict with openssl, see #28258
    rm lib/"libssl.a"

    (bin/"nss-config").write config_file
    (lib/"pkgconfig/nss.pc").write pc_file
  end

  test do
    # See: https://developer.mozilla.org/docs/Mozilla/Projects/NSS/tools/NSS_Tools_certutil
    (testpath/"passwd").write("It's a secret to everyone.")
    system "#{bin}/certutil", "-N", "-d", pwd, "-f", "passwd"
    system "#{bin}/certutil", "-L", "-d", pwd
  end

  # A very minimal nss-config for configuring firefox etc. with this nss,
  # see https://bugzil.la/530672 for the progress of upstream inclusion.
  def config_file
    <<~EOS
      #!/bin/sh
      for opt; do :; done
      case "$opt" in
        --version) opt="--modversion";;
        --cflags|--libs) ;;
        *) exit 1;;
      esac
      pkg-config "$opt" nss
    EOS
  end

  def pc_file
    <<~EOS
      prefix=#{prefix}
      exec_prefix=${prefix}
      libdir=${exec_prefix}/lib
      includedir=${prefix}/include/nss

      Name: NSS
      Description: Mozilla Network Security Services
      Version: #{version}
      Requires: nspr >= 4.12
      Libs: -L${libdir} -lnss3 -lnssutil3 -lsmime3 -lssl3
      Cflags: -I${includedir}
    EOS
  end
end
