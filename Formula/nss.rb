class Nss < Formula
  desc "Libraries for security-enabled client and server applications"
  homepage "https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS"
  url "https://ftp.mozilla.org/pub/security/nss/releases/NSS_3_87_RTM/src/nss-3.87.tar.gz"
  sha256 "68a1894496d3d158babc75f8a5dda3f55b7c1560573936e3b101a10fa4ac152d"
  license "MPL-2.0"

  livecheck do
    url "https://ftp.mozilla.org/pub/security/nss/releases/"
    regex(%r{href=.*?NSS[._-]v?(\d+(?:[._]\d+)+)[._-]RTM/?["' >]}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match.first.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e49b7739ca2a84d5a8f9eb6423a2bf99d4f741554f689b04dcbe97a36abd8359"
    sha256 cellar: :any,                 arm64_monterey: "18bda960cfcd60ea0031f93e136ec363ca136a805605c5841909a8ba8b5eb6ed"
    sha256 cellar: :any,                 arm64_big_sur:  "a7c9c7cc3186853c50a422a8da7e501b7c05b9e5a4f27a9b99281988892e78c9"
    sha256 cellar: :any,                 ventura:        "b0685930bea61b8ce13725b4df58584503628473b636e5fefe0eec8dfd5ba1b3"
    sha256 cellar: :any,                 monterey:       "814c110786ea23bb37c2b86559e0c0f7f9e78f2ea7bd5c6c528a5488895367d1"
    sha256 cellar: :any,                 big_sur:        "f578a357624128528f938c6ea422957f33e7971aded6bde44df00f7ef857fa28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c67f27aec4b61bf6cda6187379b9b4e6842d5d6614e60f6fb92db538aadde5c"
  end

  depends_on "nspr"

  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  conflicts_with "arabica", because: "both install `mangle` binaries"
  conflicts_with "resty", because: "both install `pp` binaries"

  def install
    ENV.deparallelize
    cd "nss"

    args = %W[
      BUILD_OPT=1
      NSS_ALLOW_SSLKEYLOGFILE=1
      NSS_DISABLE_GTESTS=1
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
    os = OS.kernel_name
    Dir.glob("#{os}*/bin/*") do |file|
      cp file, bin unless file.include? ".dylib"
    end

    include_target = include + "nss"
    include_target.mkpath
    Dir.glob("public/{dbm,nss}/*") { |file| cp file, include_target }

    lib.mkpath
    libexec.mkpath
    Dir.glob("#{os}*/lib/*") do |file|
      if file.include? ".chk"
        cp file, libexec
      else
        cp file, lib
      end
    end
    # resolves conflict with openssl, see legacy-homebrew#28258
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
