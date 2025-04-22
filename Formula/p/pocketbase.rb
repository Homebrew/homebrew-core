class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.27.1.tar.gz"
  sha256 "74f1b47ce08e0b32fc0ac6f9d4f56b69f3d1ca345fec7f1ed6d1c282560286e9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1069cc16caa08429b697148fb6cfd896d96eb98038dab25106c5718417ab1ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1069cc16caa08429b697148fb6cfd896d96eb98038dab25106c5718417ab1ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c1069cc16caa08429b697148fb6cfd896d96eb98038dab25106c5718417ab1ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "acf45ab287a0dcf38a0b991c8cf13725ed98d3f96961f9a998525a94ba1e3f4d"
    sha256 cellar: :any_skip_relocation, ventura:       "acf45ab287a0dcf38a0b991c8cf13725ed98d3f96961f9a998525a94ba1e3f4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6baca57dd798fac27433619e67b3ccda7c49de7f3dfa5a16452cb05fe669f275"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4e9770513a1d962b8df04cd1f758bc0da6580d1cfbda6310f0dd2b17288c901"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/pocketbase/pocketbase.Version=#{version}"), "./examples/base"
  end

  test do
    assert_match "pocketbase version #{version}", shell_output("#{bin}/pocketbase --version")

    port = free_port
    PTY.spawn("#{bin}/pocketbase serve --dir #{testpath}/pb_data --http 127.0.0.1:#{port}") do |_, _, pid|
      sleep 5

      assert_match "API is healthy", shell_output("curl -s http://localhost:#{port}/api/health")

      assert_path_exists testpath/"pb_data", "pb_data directory should exist"
      assert_predicate testpath/"pb_data", :directory?, "pb_data should be a directory"

      assert_path_exists testpath/"pb_data/data.db", "pb_data/data.db should exist"
      assert_predicate testpath/"pb_data/data.db", :file?, "pb_data/data.db should be a file"

      assert_path_exists testpath/"pb_data/auxiliary.db", "pb_data/auxiliary.db should exist"
      assert_predicate testpath/"pb_data/auxiliary.db", :file?, "pb_data/auxiliary.db should be a file"
    ensure
      Process.kill "TERM", pid
    end
  end
end
