class Benchi < Formula
  desc "Benchmarking tool for data pipelines"
  homepage "https://github.com/ConduitIO/benchi"
  url "https://github.com/ConduitIO/benchi/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "0f6d9c21ea9d3bc2bff689cb4a258bdf4aa36c7b1e92443d74414a5826ddfefc"
  license "Apache-2.0"
  head "https://github.com/ConduitIO/benchi.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/benchi"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/benchi -v")
  end
end
