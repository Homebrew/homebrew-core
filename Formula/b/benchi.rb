class Benchi < Formula
  desc "Benchmarking tool for data pipelines"
  homepage "https://github.com/ConduitIO/benchi"
  url "https://github.com/ConduitIO/benchi/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "c97fc9f2e2fac7be61e9e9c2282e7ee1c9a5da78c3d6c10e40c472b1e79168ab"
  license "Apache-2.0"
  head "https://github.com/ConduitIO/benchi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "345f2cb5010d9484cb706db47b011fcf1803f7362edbfa566fa91c3b6dc4a661"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef982909669f57484c15967889e31d9dcbeaabbfa7c06e4679b3cb3cf80813d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e068e8f02585836ec56621b89ee08f4f7e16227937a94e2506afa3281f41e6aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b234153232acdc8ce535e346c7dabc901982ef1e85560b398961c7c9d1f7fb88"
    sha256 cellar: :any_skip_relocation, sonoma:        "81b0da33bf40b9125ed50e1e1797204c92db8e4b399d2d6b789a0a1f80037ff0"
    sha256 cellar: :any_skip_relocation, ventura:       "db0e879626f4ab89d1508c1c39a5122368d0ca2f67ffef4e9e7409f49d0a5ad7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae2ad857f711eedc3a3ce6c7b2a30d2476b46bc3fedc1d1ce1d7e9817b75e35a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e569ae18bead940da25254a002675e11578f3be5c81d631bb39db717a4439db"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/benchi"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/benchi -v")

    # Fails in Linux CI with "open /dev/tty: no such device or address"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    test_config = testpath/"bench.yml"
    test_config.write <<~YAML
      name: test-benchmark
      iterations: 1
      pipeline:
        source:
          type: generator
          config:
            records: 1
        processors: []
        destination:
          type: noop
    YAML

    output = shell_output("#{bin}/benchi -config #{test_config} -out #{testpath} 2>&1", 1)
    assert_match "Cannot connect to the Docker daemon", output
  end
end
