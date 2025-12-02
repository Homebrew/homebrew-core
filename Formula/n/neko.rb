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
    sha256 arm64_tahoe:   "db9c53fdb4451846f55a6f6ea2e55e63a7c0082e53f76f3b8f5de867941c13a2"
    sha256 arm64_sequoia: "afa51940db454f45a94290ba51504b6474dff0e8092c146515467b22b872ca84"
    sha256 arm64_sonoma:  "2129d1b4dd39b1324c8ef30dacad869d9f3ae99713cf93cb69b80fd2133ba4ba"
    sha256 sonoma:        "b8237d39231cd951d8a3fe202e9deab64b488afa90e8efcf652c4b8004aeefdb"
    sha256 arm64_linux:   "34f29f334c16a1991d9b85bf4e1133b0fdc40668252b6a61670c55a1796d296b"
    sha256 x86_64_linux:  "d07d44819e109acb2959ae8bc38dd77102da555a846795a27b064b3fbe6c90bc"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "bdw-gc"
  depends_on "mariadb-connector-c"
  depends_on "mbedtls@3"
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
