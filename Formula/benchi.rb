class Benchi < Formula
  desc "Benchmarking tool for data pipelines"
  homepage "https://github.com/ConduitIO/benchi"
  url "https://github.com/ConduitIO/benchi/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "0f6d9c21ea9d3bc2bff689cb4a258bdf4aa36c7b1e92443d74414a5826ddfefc"
  license "Apache-2.0"
  head "https://github.com/ConduitIO/benchi.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags:), "./cmd/benchi"
    bin.install "benchi"
  end

  test do
    # Test actual user functionality by running a simple benchmark
    system "#{bin}/benchi", "run", "--config", "example/config.yaml"
  end
end 