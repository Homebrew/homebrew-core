class Nng < Formula
  desc "Nanomsg-next-generation -- light-weight brokerless messaging"
  homepage "https://nng.nanomsg.org/"
  url "https://github.com/nanomsg/nng/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "50b7264bd8f0901f7ebdf3ec7c48f4e23dd689bbe7b2917d9d8fad58ffd09e5c"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "36e568fca0598bc6366621a3f9eaa5f5b29f47e5b66d29c38dd2052bb044bc36"
    sha256 cellar: :any, arm64_sequoia: "c0224f94a3a9efe41f09d61eb34d2806da327bf95005426aa82f212e1487c2bb"
    sha256 cellar: :any, arm64_sonoma:  "505c649f3c22aaacfd9c912eb70139541488767e731dfe6728a8ffaccfbbcf6f"
    sha256 cellar: :any, sonoma:        "78b0159716d0d633117bccd261d669955eec866ebb0043b27e46649d55cb463a"
    sha256 cellar: :any, arm64_linux:   "28f843a5feca02863d836001925eb8c07099ee5cbee78d00fe80e5e61bc41f72"
    sha256 cellar: :any, x86_64_linux:  "bd79ffa56d9178436f8df24f810b4eb0c10ffdaae59759b942150984e296f950"
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
