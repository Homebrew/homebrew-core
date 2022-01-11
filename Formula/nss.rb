class Nss < Formula
  desc "Libraries for security-enabled client and server applications"
  homepage "https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS"
  url "https://ftp.mozilla.org/pub/security/nss/releases/NSS_3_74_RTM/src/nss-3.74.tar.gz"
  sha256 "88928811f9f40f87d42e2eaccdf6e454562e51486067f2ddbe90aa47ea6cd056"
  license "MPL-2.0"

  livecheck do
    url "https://ftp.mozilla.org/pub/security/nss/releases/"
    regex(%r{href=.*?NSS[._-]v?(\d+(?:[._]\d+)+)[._-]RTM/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "bcadb2b42b34d5fdcfc549baa9eaa5a135a4606150061c82902dbb6d05adf233"
    sha256 cellar: :any,                 arm64_big_sur:  "74a5c018bd4d9ae51b736b8d14eed1f2b62e8212749ffa1efe203ca778cc0d85"
    sha256 cellar: :any,                 monterey:       "dd78686dabd11e48f53c126cb11a13831e99aebe242a959b53d1e6d5cb0b81fc"
    sha256 cellar: :any,                 big_sur:        "79359ad7312b4658dabb1db922ed52ce54264534da24ebcb72ff34c62de9964c"
    sha256 cellar: :any,                 catalina:       "0b55501276d866858272d075df659ab01bbf3ddbac3cbdb2b5815f2b6ec35ad7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f3520de03df679a4bd0f85c7088d9a2c0ad40499042b269096ee8628a1fb888"
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
