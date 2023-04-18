class Neko < Formula
  desc "High-level, dynamically typed programming language"
  homepage "https://nekovm.org/"
  url "https://github.com/HaxeFoundation/neko/archive/v2-3-0/neko-2.3.0.tar.gz"
  sha256 "850e7e317bdaf24ed652efeff89c1cb21380ca19f20e68a296c84f6bad4ee995"
  license "MIT"
  revision 7
  head "https://github.com/HaxeFoundation/neko.git", branch: "master"

  bottle do
    sha256                               arm64_ventura:  "7884de8412bd4275f2ad1d64391b7b42c3c816143a8ae6f13b268bb2e9aa29a4"
    sha256                               arm64_monterey: "5c98fefc1af0c5b4391c48c2c28957f3b11e635b4f6fdf2b8a274a9b3d71c6fc"
    sha256                               arm64_big_sur:  "7dc2386e227172ce35a3c01583bcac98793e3477f23ac0dd764514fb1ad8126d"
    sha256                               ventura:        "41e4b5cafe8330cabb6fb97ec386beb2a0390a2f89a2d91a3c0ff325d3cdba7b"
    sha256                               monterey:       "25484b429d41aba93aed15be888c59bcf33247936c2fc0bfc4aa657324aaee7e"
    sha256                               big_sur:        "c58be5fa39965347a20657f83e980e6a8b92c055b47e2425c1cd4ee228d76f9b"
    sha256                               catalina:       "a6d4dfa77a8de46e49eb8cad58fd2423f6e0c57fc6788941bef81ea9abc02ad2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b85cdf1112098a5bb933676765efd29c446cf58a994f02e914b113681e84009"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "bdw-gc"
  depends_on "mbedtls@2"
  depends_on "openssl@1.1"
  depends_on "pcre"

  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  on_linux do
    depends_on "apr"
    depends_on "apr-util"
    depends_on "gtk+" # On mac, neko uses carbon. On Linux it uses gtk2
    depends_on "httpd"
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
    mysql_cmake_args = ["-Wno-dev", "-DWITH_EXTERNAL_ZLIB=1"]
    if OS.mac?
      mysql_cmake_args << "-DICONV_LIBRARIES=-liconv"
      mysql_cmake_args << "-DICONV_INCLUDE_DIR="
    end
    inreplace "libs/mysql/CMakeLists.txt", "-Wno-dev", mysql_cmake_args.join(" ")

    args = std_cmake_args
    if OS.linux?
      args << "-DAPR_LIBRARY=#{Formula["apr"].opt_lib}"
      args << "-DAPR_INCLUDE_DIR=#{Formula["apr"].opt_include}/apr-1"
      args << "-DAPRUTIL_LIBRARY=#{Formula["apr-util"].opt_lib}"
      args << "-DAPRUTIL_INCLUDE_DIR=#{Formula["apr-util"].opt_include}/apr-1"
    end

    # Let cmake download its own copy of MariaDBConnector during build and statically link it.
    # It is because there is no easy way to define we just need any one of mariadb, mariadb-connector-c,
    # mysql, and mysql-client.
    mkdir "build" do
      system "cmake", "..", "-G", "Ninja", "-DSTATIC_DEPS=MariaDBConnector",
             "-DRELOCATABLE=OFF", "-DRUN_LDCONFIG=OFF", *args
      system "ninja", "install"
    end
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
