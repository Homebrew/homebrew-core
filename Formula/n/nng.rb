class Nng < Formula
  desc "Nanomsg-next-generation -- light-weight brokerless messaging"
  homepage "https://nanomsg.github.io/nng/"
  url "https://github.com/nanomsg/nng/archive/refs/tags/v1.10.tar.gz"
  sha256 "7388923985ada3abe73d27400aec1f2abf418df1231875e82ffd88e752a143ba"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "32d746d712d540f04c2970f599f9d3139d758d8b04ec76d488a5ba78b9e06533"
    sha256 cellar: :any,                 arm64_sonoma:  "0a36a6700be0c520a162ee5c2bac665bc68180e88f17f77b89bf13d47e90a31b"
    sha256 cellar: :any,                 arm64_ventura: "e84db04e3b7ec8f22114debf1484a8246507cce7e327d3cf2949a93294867c71"
    sha256 cellar: :any,                 sonoma:        "5ea2b828b2865a2138107c784676c21d4540a77b9bcef3c22d4a820710ff180b"
    sha256 cellar: :any,                 ventura:       "b85346233d5785c4f42cff03a5297f6f16cffe4bd6331d85d8cf231652642919"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7dcde6e6c8dbab0c1e3b987e580a150b2d8290378a953f6178314a94a5d29558"
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
