class Nng < Formula
  desc "Nanomsg-next-generation -- light-weight brokerless messaging"
  homepage "https://nng.nanomsg.org/"
  url "https://github.com/nanomsg/nng/archive/refs/tags/v1.12.4.tar.gz"
  sha256 "93b177727ec5ea38af5c88ab297f732ef71ddc4700d2407c4f9c999b3a7310a0"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "232b67f462d9b24423f7eb82b6ab844fe342a257696e66dfb43e67c490300726"
    sha256 cellar: :any, arm64_tahoe:       "c5b75bce95f0f448b9d0cb503736d6265983fc23b6c68379cd949afcd76fcb2f"
    sha256 cellar: :any, arm64_sequoia:     "a85a9ba8882f04b2e5951928deacf2f493bee9252fb7df8ca1fdc370fdc6546d"
    sha256 cellar: :any, arm64_sonoma:      "4b22094d50b900f9253d584a03f49ee09b324e4c056dba55832555e8270e491c"
    sha256 cellar: :any, arm64_linux:       "2459736812533272a852f37676bca391f515872c929d97face0dc9131f533610"
    sha256 cellar: :any, x86_64_linux:      "95aa940b8e3b141d142641592bc92daaf52aa173443e131489fc382a321f0bf3"
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
