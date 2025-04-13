class Nss < Formula
  desc "Libraries for security-enabled client and server applications"
  homepage "https://firefox-source-docs.mozilla.org/security/nss/index.html"
  url "https://ftp.mozilla.org/pub/security/nss/releases/NSS_3_110_RTM/src/nss-3.110.tar.gz"
  sha256 "9cd610c40422a07771b9b45166be2d052ea2f00b605a7928129e1f2071b3ae27"
  license "MPL-2.0"

  livecheck do
    url "https://ftp.mozilla.org/pub/security/nss/releases/"
    regex(%r{href=.*?NSS[._-]v?(\d+(?:[._]\d+)+)[._-]RTM/?["' >]}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match.first.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8ce72d9fb7a72fca71ea3a2e9c5971c4815dc9e14a4d125bda30a30eea7086a7"
    sha256 cellar: :any,                 arm64_sonoma:  "347b104ca89d0eea4c0020570591ebc8256041886f802be6263c080865d51e2d"
    sha256 cellar: :any,                 arm64_ventura: "b6a936949824fab7465d1faaabba07fd9edded9a02a870bf441ad9bd38660bd8"
    sha256 cellar: :any,                 sonoma:        "1f2fb3834b21e69be078a20733e6d276840fa8d9236a2105957ac9369c6ba534"
    sha256 cellar: :any,                 ventura:       "24d9acc79fc91ce9cbcb572d64725c653c40b6550f0bf6a9205ed1b733760110"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f59a421182d02803c62166ad9da95080088e4cb71226035b3348468b5350bc81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64ba90382ca08f2fd26059a582ebff7fcf592812daece6a62ad27d822e30d961"
  end

  depends_on "nspr"

  uses_from_macos "sqlite"
  uses_from_macos "zlib"

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
    system bin/"certutil", "-N", "-d", pwd, "-f", "passwd"
    system bin/"certutil", "-L", "-d", pwd
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
