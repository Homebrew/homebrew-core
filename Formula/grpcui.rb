class Grpcui < Formula
  desc "Interactive web UI for gRPC, along the lines of postman"
  homepage "https://github.com/fullstorydev/grpcui"
  url "https://github.com/fullstorydev/grpcui/archive/v1.1.0.tar.gz"
  sha256 "1a7c0eac76805350ccf38d6db77ed959a04f7a4a76c60897decca21a2ff49933"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "20dfef3c9bf2caaac88ab5af5f934f208e7d24583450709a849f4e3d8cab6803"
    sha256 cellar: :any_skip_relocation, big_sur:       "316b3929786b948f6d18d580c3bf9d59a414bba3acac1520017972af55cddca0"
    sha256 cellar: :any_skip_relocation, catalina:      "c6c62dbe114c2bb1de1a0c19d7845bdf2fe758e1810721772888776332a28897"
    sha256 cellar: :any_skip_relocation, mojave:        "9f5c2e8b3bdc9e0d4609819503f4a10de72cba88b7fb4aa614e5c315975f7436"
    sha256 cellar: :any_skip_relocation, high_sierra:   "af7abe614d2e96ce599ec1683ad9ec94c51daaf5d72613ad9c4bdedb7c9a4495"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5981bed2db80a0144c44f02f06fe9a6ad6c1b6012106faabe561e56f0e9833e7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-X main.version=#{version}", "./cmd/grpcui"
  end

  test do
    host = "no.such.host.dev"
    output = shell_output("#{bin}/grpcui #{host}:999 2>&1", 1)
    assert_match(/Failed to dial target host "#{Regexp.escape(host)}:999":.*: no such host/, output)
  end
end
