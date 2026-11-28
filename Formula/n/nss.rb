class Nss < Formula
  desc "Libraries for security-enabled client and server applications"
  homepage "https://firefox-source-docs.mozilla.org/security/nss/index.html"
  url "https://ftp.mozilla.org/pub/security/nss/releases/NSS_3_134_RTM/src/nss-3.134.tar.gz"
  sha256 "bb3b300b457f44da9a9486917c3b33bbc5935ae3cdf60aa759a6880889439c50"
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
    manifest_sha256 "2904817b93a5fce028ce860e8ecdef21e7c26f9d4d8682a180955d03b36519e9"
    sha256 cellar: :any, arm64_golden_gate: "67fd8cd45a6cdef966d13bcfc8d5fa1f08735ee8a72fa1ff61bd905ee86350e1"
    sha256 cellar: :any, arm64_tahoe:       "c65937972682479a5dde0108607c10227c4e3f7e239ba2d138554b8cd710a9ad"
    sha256 cellar: :any, arm64_sequoia:     "fbcd7c31872709eedf1f5221b21ab0bbbe569c5d7809478ea192e39b3d9eb727"
    sha256 cellar: :any, arm64_linux:       "e857856a5c9c7bd7b23f0b071a11543a5bf804ff44d552fa3ec7e48f50140ed0"
    sha256 cellar: :any, x86_64_linux:      "9628a3c7ec0fd8fe2dd521ebaf9dd04bf9275994fdd5af8f1ac4e51d6cb8d1a3"
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
    # Keep subdirectories such as `mozpkix`, which its headers include as `mozpkix/*.h`
    Dir.glob("public/{dbm,nss}/**/*") do |file|
      next if File.directory?(file)

      target = include_target/Pathname(file).each_filename.drop(2).join("/")
      target.dirname.mkpath
      cp file, target
    end

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

    # A very minimal nss-config for configuring firefox etc. with this nss,
    # see https://bugzil.la/530672 for the progress of upstream inclusion.
    (bin/"nss-config").write <<~SH
      #!/bin/sh
      for opt; do :; done
      case "$opt" in
        --version) opt="--modversion";;
        --cflags|--libs) ;;
        *) exit 1;;
      esac
      pkg-config "$opt" nss
    SH
    (lib/"pkgconfig/nss.pc").write <<~PC
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

  test do
    # See: https://developer.mozilla.org/docs/Mozilla/Projects/NSS/tools/NSS_Tools_certutil
    (testpath/"passwd").write("It's a secret to everyone.")
    system bin/"certutil", "-N", "-d", pwd, "-f", "passwd"
    system bin/"certutil", "-L", "-d", pwd
  end
end
