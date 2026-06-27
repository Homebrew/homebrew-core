class Nng < Formula
  desc "Nanomsg-next-generation -- light-weight brokerless messaging"
  homepage "https://nng.nanomsg.org/"
  url "https://github.com/nanomsg/nng/archive/refs/tags/v1.11.tar.gz"
  sha256 "12aaff6f8f183ba0fec378af8620c47cf4be6da975d016ec6cdec2fbac0d3534"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d1c5d69e4cd6874e9fc3a6c7d95e8444c730d7b9d4bddcb74092bf5c53a7b0c4"
    sha256 cellar: :any,                 arm64_sequoia: "c8b949fcace671131602004d36dd682e84a8f11c294121883780bed5c37207e3"
    sha256 cellar: :any,                 arm64_sonoma:  "787e01ff6e0b46d61794bb151e18ff2af1dfcb590f2721eb35187c1de60ea3d9"
    sha256 cellar: :any,                 arm64_ventura: "33847914c92079fae13338b6099d547957a33b9142c50196919080a23196a74d"
    sha256 cellar: :any,                 sonoma:        "f21583c80dc1ccd84cde614cb8ea7a8b7e7586ecd39aae010583a038e562580d"
    sha256 cellar: :any,                 ventura:       "5a4c09d6a83310a8117cbeb2df1f292581a7a32eff9f0c0db6a3d9172b47a6d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7df32fb58d3135bbeb0b9046534a0fb901dacfddc215546855146b3102c52eeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25761374c9d2ca6fedff91630fb23e7fe10ae9f68369f7eaaddc1fa5ffc35e6b"
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
