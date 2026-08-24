class Nng < Formula
  desc "Nanomsg-next-generation -- light-weight brokerless messaging"
  homepage "https://nng.nanomsg.org/"
  url "https://github.com/nanomsg/nng/archive/refs/tags/v1.12.2.tar.gz"
  sha256 "a6e03b6cb3c8c7abb371b9a58e0f070b9cd7bed132999032aa8fcd084cd7787f"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "48f921b8396dcdad07ab86131ff6d14b4b35a617d37c3e37def222d193b42f3b"
    sha256 cellar: :any, arm64_sequoia: "6217b28b7a610c9a991c5ac264e49b815e5b43ac5eb86461ccd767da8b774e50"
    sha256 cellar: :any, arm64_sonoma:  "5f34d4c85749cd7edaf73161b414a737b4bdec905055e504596c342016053cf7"
    sha256 cellar: :any, sonoma:        "f6e7a96f1142f5a9038c2dc992571f9c0ebbb480ecb56afd799e6fd79e90e7af"
    sha256 cellar: :any, arm64_linux:   "b3120be1deb26152ff007d16c92f21b14a0794c29ed284cdf5e4ef41e31be368"
    sha256 cellar: :any, x86_64_linux:  "0778c2a7a835c4287a3bc0038bb473409d5db50069105b4b3e52ceb51583271c"
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
