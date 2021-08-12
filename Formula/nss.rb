class Nss < Formula
  desc "Libraries for security-enabled client and server applications"
  homepage "https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS"
  url "https://ftp.mozilla.org/pub/security/nss/releases/NSS_3_69_RTM/src/nss-3.69.tar.gz"
  sha256 "c880205a365e0dd488ff29fdea82716ff9fcde9da6f3b703d636f8fc08008799"
  license "MPL-2.0"

  livecheck do
    url "https://ftp.mozilla.org/pub/security/nss/releases/"
    regex(%r{href=.*?NSS[._-]v?(\d+(?:[._]\d+)+)[._-]RTM/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "80c110ce776dd9b6c9c489309cc23c7d8c4310090bbfd09f036e98b7d02ee74d"
    sha256 cellar: :any,                 big_sur:       "1c83a6a1050562b3678e648f68a714c7567ee33c4c9069679048b8902d8d767f"
    sha256 cellar: :any,                 catalina:      "4e540f49497c9932fbb3b65e5187bf0cced546f02c94f8b19963714b96d18051"
    sha256 cellar: :any,                 mojave:        "fba80d27ad01ec389493d80768c08f50e9189e26f5c097d83149be80c22c0789"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd827672eec70f4b1ee80867ab1bb9d86f674f39c3c57efd578bb93a16d5d49b"
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
    os = "Darwin"
    on_linux { os = "Linux" }
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
