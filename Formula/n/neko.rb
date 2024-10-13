class Neko < Formula
  desc "High-level, dynamically typed programming language"
  homepage "https://nekovm.org/"
  url "https://github.com/HaxeFoundation/neko/archive/refs/tags/v2-4-0.tar.gz"
  version "2.4.0"
  sha256 "232d030ce27ce648f3b3dd11e39dca0a609347336b439a4a59e9a5c0a465ce15"
  license "MIT"
  revision 1
  head "https://github.com/HaxeFoundation/neko.git", branch: "master"

  bottle do
    sha256 arm64_sequoia:  "6b49445459efe4047cdb5699d9ae8f73bb05941dbaf3eb4ccd910ca9aca754d4"
    sha256 arm64_sonoma:   "fdad9a6dc773dffe3b1e55971758cfda775e8b473c7d135319c9c65528167b22"
    sha256 arm64_ventura:  "9b40ecbae0b6a62cd9d32d19fecfb3a429e90660e194a0b2cc12ea5052f50976"
    sha256 arm64_monterey: "71589dcf0a4ec18650f32439cff9caefdfdae7179b666d883acb9fa96b38cee7"
    sha256 sonoma:         "15e070b6148e6bc15387ee1958c6f815d3bbacbf67438e073e8fd21f6b9deb3f"
    sha256 ventura:        "4f19f161bbf2c088fe1e06b08082ac555999f4102d3c6f6a281aeda79e318572"
    sha256 monterey:       "9615b73250454cf485ffc61a3190f0e5cd8a9769847d3ba914322266d3463d15"
    sha256 x86_64_linux:   "50db5d00af036fd2803c42b1739c3038382a7f68cc3f75f785444564f6764f9b"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "bdw-gc"
  depends_on "mbedtls"
  depends_on "mysql-client"
  depends_on "pcre2"
  depends_on "zlib" # due to `mysql-client`

  uses_from_macos "sqlite"

  on_linux do
    depends_on "apr"
    depends_on "apr-util"
    depends_on "gtk+3" # On mac, neko uses carbon. On Linux it uses gtk3
    depends_on "httpd"
  end

  def install
    args = %w[
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
    system "cmake", "--build", "build"
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
