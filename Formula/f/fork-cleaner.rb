class ForkCleaner < Formula
  desc "Cleans up old and inactive forks on your GitHub account"
  homepage "https://github.com/caarlos0/fork-cleaner"
  url "https://github.com/caarlos0/fork-cleaner/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "28ded4826d8a36d25857b824bea1ae480c76029ff50e8d831f79e18c360ff032"
  license "MIT"
  head "https://github.com/caarlos0/fork-cleaner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4d65037eb6fa84966a7d0739f6f9291bec56c4d9570cf55e158b9d08b8621f7e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d65037eb6fa84966a7d0739f6f9291bec56c4d9570cf55e158b9d08b8621f7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d65037eb6fa84966a7d0739f6f9291bec56c4d9570cf55e158b9d08b8621f7e"
    sha256 cellar: :any_skip_relocation, sonoma:        "97d7f18ad8794af667717bdac50c24d0830691bb3f23d6bc2ff1a9f12a6a75cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb74331bc4d12930081b084cc5748e3d055be6653c5128f5e5dfb65ebe4313ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee7dc6c7d5b873e5fb7a52ebb8080ec5c544380842527522b161fdca7f79a593"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/fork-cleaner"
  end

  test do
    output = shell_output("#{bin}/fork-cleaner 2>&1", 1)
    assert_match "missing github token", output
  end
end
