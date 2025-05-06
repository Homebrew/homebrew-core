class Neko < Formula
  desc "High-level, dynamically typed programming language"
  homepage "https://nekovm.org/"
  url "https://github.com/HaxeFoundation/neko/archive/refs/tags/v2-4-1.tar.gz"
  version "2.4.1"
  sha256 "702282028190dffa2078b00cca515b8e2ba889186a221df2226d2b6deb3ffaca"
  license "MIT"
  head "https://github.com/HaxeFoundation/neko.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "6089dd1e4fe69503a105375a9533dbe582794eee99d6cae8ac2743b849439d57"
    sha256 arm64_sonoma:  "dd942c346ec9687a7e998c82280ea88c01c56ec7aa9629f3fefedd7e927bd40a"
    sha256 arm64_ventura: "073b6bcbcaf97dec3f1ebdd4c628ce6afc2f222ae2813387f8148e4aa1400451"
    sha256 sonoma:        "5e961a790c898530c2218cada8c03741028d46b617b7c1b895d2256389cb85da"
    sha256 ventura:       "6b860ebf76d071afb52369220c3021c935a54e9bcfedf877ebdc01395af3bbc0"
    sha256 arm64_linux:   "bd2ecd42df25c5a31a83069b25acf108c005c8c861771c4c33390633829e0d06"
    sha256 x86_64_linux:  "6aab8930e6a10748212eec532bf2ce096d036934908fa2f66be055165c1802fe"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "bdw-gc"
  depends_on "mariadb-connector-c"
  depends_on "mbedtls"
  depends_on "pcre2"

  uses_from_macos "apr"
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  on_linux do
    depends_on "apr-util"
    depends_on "gtk+3" # On mac, neko uses carbon. On Linux it uses gtk3
    depends_on "httpd"
  end

  def install
    args = %W[
      -DMARIADB_CONNECTOR_LIBRARIES=#{Formula["mariadb-connector-c"].opt_lib/"mariadb"/shared_library("libmariadb")}
      -DRELOCATABLE=OFF
      -DRUN_LDCONFIG=OFF
    ]
    if OS.linux?
      args << "-DAPR_LIBRARY=#{Formula["apr"].opt_lib}"
      args << "-DAPR_INCLUDE_DIR=#{Formula["apr"].opt_include}/apr-1"
      args << "-DAPRUTIL_LIBRARY=#{Formula["apr-util"].opt_lib}"
      args << "-DAPRUTIL_INCLUDE_DIR=#{Formula["apr-util"].opt_include}/apr-1"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    ENV.deparallelize { system "cmake", "--build", "build" }
    system "cmake", "--install", "build"
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
    system bin/"neko", "-version"
    (testpath/"hello.neko").write '$print("Hello world!\n");'
    system bin/"nekoc", "hello.neko"
    assert_equal "Hello world!\n", shell_output("#{bin}/neko hello")
  end
end
