class Neko < Formula
  desc "High-level, dynamically typed programming language"
  homepage "https://nekovm.org/"
  url "https://github.com/HaxeFoundation/neko/archive/refs/tags/v2-4-0.tar.gz"
  version "2.4.0"
  sha256 "232d030ce27ce648f3b3dd11e39dca0a609347336b439a4a59e9a5c0a465ce15"
  license "MIT"
  revision 2
  head "https://github.com/HaxeFoundation/neko.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "b38501d676f50f59850268cb391d22609b8e44cb1e519ccee69f232181a8daf0"
    sha256 arm64_sonoma:  "aa8361053feb6c94e6398a6fa7e788b5d3e276b7c6f9e215bde0902436655cf3"
    sha256 arm64_ventura: "a2bb17a1c4a91c23474106fd66aad13a65c9d2b448be0c40e93492fe62599f09"
    sha256 sonoma:        "e9fe8e7903973df0a11cb1db8a0889f956575a643fa7f1004fb35a1af422d7a8"
    sha256 ventura:       "628a94ee78dca18979beb02740d94c958bcfcad8f75d70760c5ef67dda547ac6"
    sha256 x86_64_linux:  "78c31987c7dd238bf52a2a95b93835f114e11756cb974d761d5325e1474222e5"
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
