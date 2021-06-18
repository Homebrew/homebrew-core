class Neko < Formula
  desc "High-level, dynamically typed programming language"
  homepage "https://nekovm.org/"
  url "https://github.com/HaxeFoundation/neko/archive/v2-3-0/neko-2.3.0.tar.gz"
  sha256 "850e7e317bdaf24ed652efeff89c1cb21380ca19f20e68a296c84f6bad4ee995"
  license "MIT"
  revision 4
  head "https://github.com/HaxeFoundation/neko.git"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_big_sur: "ece8bc64b6653a08e64d1641bb8ce38ab2c1b9652953ae4ab4ade96c7cbbbce4"
    sha256 cellar: :any, big_sur:       "b709a1c46fd41c3d0f2e09ef65624e5e286408c885b8eb773806533d251c5550"
    sha256 cellar: :any, catalina:      "3c3942cb5d805125d765c401688fb8dc8a66047d21e1e9e10522ecd94de58c21"
    sha256 cellar: :any, mojave:        "6fbefe32d592b7fe197ea6e2e891b9da0d2d34ead8e5a44306714d16c4b40042"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "bdw-gc"
  depends_on "mbedtls"
  depends_on "openssl@1.1"
  depends_on "pcre"

  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  on_linux do
    depends_on "apr"
    depends_on "apr-util"
    depends_on "httpd"
    # On mac, neko uses carbon. On Linux it uses gtk2
    depends_on "gtk+"
  end

  # Don't redefine MSG_NOSIGNAL -- https://github.com/HaxeFoundation/neko/pull/217
  patch do
    url "https://github.com/HaxeFoundation/neko/commit/24a5e8658a104ae0f3afe66ef1906bb7ef474bfa.patch?full_index=1"
    sha256 "1a707e44b7c1596c4514e896211356d1b35d4e4b578b14b61169a7be47e91ccc"
  end

  # Fix -Wimplicit-function-declaration issue in libs/ui/ui.c
  # https://github.com/HaxeFoundation/neko/pull/218
  patch do
    url "https://github.com/HaxeFoundation/neko/commit/908149f06db782f6f1aa35723d6a403472a2d830.patch?full_index=1"
    sha256 "3e9605cccf56a2bdc49ff6812eb56f3baeb58e5359601a8215d1b704212d2abb"
  end

  # Fix -Wimplicit-function-declaration issue in libs/std/process.c
  # https://github.com/HaxeFoundation/neko/pull/219
  patch do
    url "https://github.com/HaxeFoundation/neko/commit/1a4bfc62122aef27ce4bf27122ed6064399efdc4.patch?full_index=1"
    sha256 "7fbe2f67e076efa2d7aa200456d4e5cc1e06d21f78ac5f2eed183f3fcce5db96"
  end

  # Fix mariadb-connector-c CMake error: "Flow control statements are not properly nested."
  # https://github.com/HaxeFoundation/neko/pull/225
  patch do
    url "https://github.com/HaxeFoundation/neko/commit/660fba028af1b77be8cb227b8a44cc0ef16aba79.patch?full_index=1"
    sha256 "7b0a60494eaef7c67cd15e5d80d867fee396ac70e99000603fba0dc3cd5e1158"
  end

  # Fix m1 specifics
  # https://github.com/HaxeFoundation/neko/pull/224
  patch do
    url "https://github.com/HaxeFoundation/neko/commit/ff5da9b0e96cc0eabc44ad2c10b7a92623ba49ee.patch?full_index=1"
    sha256 "ac843dfc7585535f3b08fee2b22e667fa6c38e62dcf8374cdfd1d8fcbdbcdcfd"
  end

  def install
    inreplace "libs/mysql/CMakeLists.txt",
              %r{https://downloads.mariadb.org/f/},
              "https://downloads.mariadb.com/Connectors/c/"

    # Work around for https://github.com/HaxeFoundation/neko/issues/216 where
    # maria-connector fails to detect the location of iconv.dylib on Big Sur.
    # Also, no reason for maria-connector to compile its own version of zlib,
    # just link against the system copy.
    inreplace "libs/mysql/CMakeLists.txt",
              "-Wno-dev",
              "-Wno-dev -DICONV_LIBRARIES=-liconv -DICONV_INCLUDE_DIR= -DWITH_EXTERNAL_ZLIB=1"

    args = std_cmake_args
    on_linux do
      args << "-DAPR_LIBRARY=#{Formula["apr"].libexec}/lib"
      args << "-DAPR_INCLUDE_DIR=#{Formula["apr"].libexec}/include/apr-1"
      args << "-DAPRUTIL_LIBRARY=#{Formula["apr-util"].libexec}/lib"
      args << "-DAPRUTIL_INCLUDE_DIR=#{Formula["apr-util"].libexec}/include/apr-1"
    end

    # Let cmake download its own copy of MariaDBConnector during build and statically link it.
    # It is because there is no easy way to define we just need any one of mariadb, mariadb-connector-c,
    # mysql, and mysql-client.
    system "cmake", ".", "-G", "Ninja", "-DSTATIC_DEPS=MariaDBConnector",
           "-DRELOCATABLE=OFF", "-DRUN_LDCONFIG=OFF", *args
    system "ninja", "install"
  end

  def caveats
    s = ""
    if HOMEBREW_PREFIX.to_s != "/usr/local"
      s << <<~EOS
        You must add the following line to your .bashrc or equivalent:
          export NEKOPATH="#{HOMEBREW_PREFIX}/lib/neko"
      EOS
    end
    s
  end

  test do
    ENV["NEKOPATH"] = "#{HOMEBREW_PREFIX}/lib/neko"
    system "#{bin}/neko", "-version"
    (testpath/"hello.neko").write '$print("Hello world!\n");'
    system "#{bin}/nekoc", "hello.neko"
    assert_equal "Hello world!\n", shell_output("#{bin}/neko hello")
  end
end
