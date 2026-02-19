class Neko < Formula
  desc "High-level, dynamically typed programming language"
  homepage "https://nekovm.org/"
  url "https://github.com/HaxeFoundation/neko/archive/refs/tags/v2-4-1.tar.gz"
  version "2.4.1"
  sha256 "702282028190dffa2078b00cca515b8e2ba889186a221df2226d2b6deb3ffaca"
  license "MIT"
  revision 1
  head "https://github.com/HaxeFoundation/neko.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "89c971ad4c60726ebc84ce4a6b5ebb675cd65a5dc400d4cc152cba7b40e52f07"
    sha256 arm64_sequoia: "45b778978d5a73833248131a9a9bb7019347237547e679aa529622b50054843d"
    sha256 arm64_sonoma:  "38ef0f1be7bf24efca084864babb69f3ef19ceaf97e473a686a61fda7f06e32a"
    sha256 sonoma:        "37b217ca868281d49936bb213ac8e27838254a04931b7f9f93493a6f40bc2f0a"
    sha256 arm64_linux:   "5c036ca3b850ae905d89e474af893486017fdbfc9aa7a8e696c62c4bfd59fddb"
    sha256 x86_64_linux:  "452562632f23c92792771f4df762168e34f51f1143ff7dc467e755c34594982c"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "bdw-gc"
  depends_on "mariadb-connector-c"
  depends_on "mbedtls@3"
  depends_on "pcre2"

  uses_from_macos "apr"
  uses_from_macos "sqlite"

  on_linux do
    depends_on "apr-util"
    depends_on "gtk+3" # On mac, neko uses carbon. On Linux it uses gtk3
    depends_on "httpd"
    depends_on "zlib-ng-compat"
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
    <<~EOS
      You must add the following line to your .bashrc or equivalent:
        export NEKOPATH="#{HOMEBREW_PREFIX}/lib/neko"
    EOS
  end

  test do
    ENV["NEKOPATH"] = "#{HOMEBREW_PREFIX}/lib/neko"
    system bin/"neko", "-version"
    (testpath/"hello.neko").write '$print("Hello world!\n");'
    system bin/"nekoc", "hello.neko"
    assert_equal "Hello world!\n", shell_output("#{bin}/neko hello")
  end
end
