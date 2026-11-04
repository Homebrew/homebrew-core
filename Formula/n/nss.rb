class Nss < Formula
  desc "Libraries for security-enabled client and server applications"
  homepage "https://firefox-source-docs.mozilla.org/security/nss/index.html"
  url "https://ftp.mozilla.org/pub/security/nss/releases/NSS_3_133_RTM/src/nss-3.133.tar.gz"
  sha256 "4d752526b9846a1d962588cfbd09b7cc2a4f6a4effbd9157d58a30e8a2573065"
  license "MPL-2.0"
  compatibility_version 1

  livecheck do
    url "https://ftp.mozilla.org/pub/security/nss/releases/"
    regex(%r{href=.*?NSS[._-]v?(\d+(?:[._]\d+)+)[._-]RTM/?["' >]}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match.first.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "32e9edd628d592b55049351c6b5d22bd1b7861522de5c3c7ae06335abecfbbe2"
    sha256 cellar: :any, arm64_tahoe:       "1db797acdfe3bf4537e30ade265d6556fe80afb2085a3608609203928ac6f822"
    sha256 cellar: :any, arm64_sequoia:     "bf93705a8dbe4ed57cec66a9550d9f8189690ae28da7ed642eb8e664f80da3b6"
    sha256 cellar: :any, arm64_linux:       "34d766776388c7f971239f053af99f5043d6d801c7a44312151721c2dd8e8b98"
    sha256 cellar: :any, x86_64_linux:      "c6e224826a0d27aac62a469369dd3c3cfff5ae73d73d4627ea544fba64d727d3"
  end

  depends_on "nspr"

  uses_from_macos "sqlite"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "arabica", because: "both install `mangle` binaries"
  conflicts_with "resty", because: "both install `pp` binaries"

  def install
    # Fails on arm64 macOS for some reason with:
    #   aes-armv8.c:14:2: error: "Compiler option is invalid"
    ENV.runtime_cpu_detection if OS.linux? || Hardware::CPU.intel?
    ENV.deparallelize
    cd "nss"

    args = %W[
      BUILD_OPT=1
      NSS_ALLOW_SSLKEYLOGFILE=1
      NSS_DISABLE_GTESTS=1
      NSS_USE_SYSTEM_SQLITE=1
      NSPR_INCLUDE_DIR=#{formula_opt_include("nspr")}/nspr
      NSPR_LIB_DIR=#{formula_opt_lib("nspr")}
      USE_64=1
    ]
    # Darwin.mk never computes LITTLE_ENDIAN, so NSS 3.128 drops -DHAVE_PLATFORM_GHASH
    args << "LITTLE_ENDIAN=1" if OS.mac?

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

    include_target = include/"nss"
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
    system bin/"certutil", "-N", "-d", pwd, "-f", "passwd"
    system bin/"certutil", "-L", "-d", pwd
  end

  # A very minimal nss-config for configuring firefox etc. with this nss,
  # see https://bugzil.la/530672 for the progress of upstream inclusion.
  def config_file
    <<~SH
      #!/bin/sh
      for opt; do :; done
      case "$opt" in
        --version) opt="--modversion";;
        --cflags|--libs) ;;
        *) exit 1;;
      esac
      pkg-config "$opt" nss
    SH
  end

  def pc_file
    <<~PC
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
    PC
  end
end
