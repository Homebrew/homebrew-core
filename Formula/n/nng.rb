class Nng < Formula
  desc "Nanomsg-next-generation -- light-weight brokerless messaging"
  homepage "https://nanomsg.github.io/nng/"
  url "https://github.com/nanomsg/nng/archive/refs/tags/v1.7.2.tar.gz"
  sha256 "40e6af7bdd5d02ee98ba8fe5fd5c149ce3e5a555f202cdc837e3ead2d7cc7534"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a31a779dedff013fe869f6e7491d2b714c1981ebbd6381352b1ebe38511018ca"
    sha256 cellar: :any,                 arm64_ventura:  "7d0f7ac83565debe3fda18431030cd9e4b0a91d092a4144b4ec39fbcf3bd3e2a"
    sha256 cellar: :any,                 arm64_monterey: "3a5cdb1d3adbf70d16d5d026dd1c49c0f1bee88d42f1bc3e66bf656b3552197e"
    sha256 cellar: :any,                 sonoma:         "cfbecb3979411128d1450e74426f6ee9ce193e3a8a32a3e8b64386d161e1968f"
    sha256 cellar: :any,                 ventura:        "46bede025529f67124a406ce5a3e88af6604b1f044b3bfe4e705cd3a0112cbfc"
    sha256 cellar: :any,                 monterey:       "b97efc60452a6c0d6c3e57431667691ce8a4339dd13c70b96e2dc17087e8ec40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a72cdf0d7a481b683fccf55efc66e8d76c9398f47c6482b0c05c08c1cde36d6d"
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
