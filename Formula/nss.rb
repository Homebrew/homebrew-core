class Nss < Formula
  desc "Libraries for security-enabled client and server applications"
  homepage "https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS"
  url "https://ftp.mozilla.org/pub/security/nss/releases/NSS_3_85_RTM/src/nss-3.85.tar.gz"
  sha256 "afd9d64510b1154debbd6cab3571e9ff64a3373898e03483e4c85cdada13d297"
  license "MPL-2.0"

  livecheck do
    url "https://ftp.mozilla.org/pub/security/nss/releases/"
    regex(%r{href=.*?NSS[._-]v?(\d+(?:[._]\d+)+)[._-]RTM/?["' >]}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match.first.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c5f721e0dfadc010e493d14b60cfca3527f63da69ac850ddc25334d69789f9a9"
    sha256 cellar: :any,                 arm64_monterey: "69ef6496975f4f198ea7b65f05b2a01bfcaf1d5c20e1c411ae8e79df704889b5"
    sha256 cellar: :any,                 arm64_big_sur:  "6198d157ab6f7ad22c73d39b175b67078e59b9bc9e3c222d57949f23a6bf2030"
    sha256 cellar: :any,                 ventura:        "9ea5ce3f204ffa3b6cd548498b21eb0741a644d970b9bced6b84d1ecad88ddfe"
    sha256 cellar: :any,                 monterey:       "24741a510dd72fe4eb2daa942fda6976c6ec99dd9cf293277e88abe3e65d7e97"
    sha256 cellar: :any,                 big_sur:        "b3f8fa7228e1eaf1fd32dd476b69fd7fe1f03eb2329848c353d6e40badf2060a"
    sha256 cellar: :any,                 catalina:       "5fa8d0e4e7bbb02a8ca3ada2b493a8b587fa2428736216515566d889fb48289a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0fc4e87b3f1675e35ef610b14d248bbd2872fae0f93a6952ae5ddedcda9c169"
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
