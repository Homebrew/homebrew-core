class Nng < Formula
  desc "Nanomsg-next-generation -- light-weight brokerless messaging"
  homepage "https://nanomsg.github.io/nng/"
  url "https://github.com/nanomsg/nng/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "cfacfdfa35c1618a28bb940e71f774a513dcb91292999696b4346ad8bfb5baff"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1a0d36ec0f356b2f8dcad8279929bf3a9693ea731f23c9f2998c734bd53714f7"
    sha256 cellar: :any,                 arm64_ventura:  "ea72c4d46fc91ac9a3282df0b3988a05236ef18d51034c085204995445738716"
    sha256 cellar: :any,                 arm64_monterey: "0da1c62a33f0b3381b5dbfdf0c7fe3ba2768fa83a752efbf893de403f59e79e5"
    sha256 cellar: :any,                 sonoma:         "c5e5dfc94870a1d80aed2d31cd8c62c9aef3d64e0cb8473aa3c62e1cb910a8a3"
    sha256 cellar: :any,                 ventura:        "9f1b9ec26ca2d760a7289f38e90650c69ee3d743d76a2143cbf39dcb27782e62"
    sha256 cellar: :any,                 monterey:       "18b5031f0cc0face0b37131740e4298d06e8a74ff03f39ff9eaa61ff88d63e8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afed5c52f369d6671f85ff3347bdba72e671215031527ef87612257440027a1c"
  end

  depends_on "asciidoctor" => :build
  depends_on "cmake" => :build
  depends_on "ninja" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja",
                    "-DNNG_ENABLE_DOC=ON",
                    "-DBUILD_SHARED_LIBS=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    bind = "tcp://127.0.0.1:#{free_port}"

    fork do
      exec "#{bin}/nngcat --rep --bind #{bind} --format ascii --data home"
    end
    sleep 2

    output = shell_output("#{bin}/nngcat --req --connect #{bind} --format ascii --data brew")
    assert_match(/home/, output)
  end
end
