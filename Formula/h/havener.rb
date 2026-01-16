class Havener < Formula
  desc "Swiss army knife for Kubernetes tasks"
  homepage "https://github.com/homeport/havener"
  url "https://github.com/homeport/havener/archive/refs/tags/v2.2.6.tar.gz"
  sha256 "f5fe8bc809694bd8c757c3ddaac91cdcc20eb9efc988dd736838b0a8bbfdf7e8"
  license "MIT"
  head "https://github.com/homeport/havener.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5404d60388456060489c36981d6e8383061e9b1e6055bb78ec29fff5faa47a87"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0302520d5de527eb9453496fe20c6cfd4e050ebce1daeaaec046fb6355f03486"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b63b5ddec07dc7740ca2c12f6c8007a3813b0df12833acd863b15f0d950c577"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd60ee955dc4f2a246632aa0e52f53434f15fdf3b6f69edaa6e7d3fc08f824ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66b014cf1e43c19b2a7dc1ff283cb27e4228ce71a6158d53f73ca7b95ed754a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8804e37af7ed905ebc1786d0b98f43e66ab003427e045f707dab585245e926b1"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/homeport/havener/internal/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/havener"

    generate_completions_from_executable(bin/"havener", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/havener version")

    assert_match "unable to get access to cluster", shell_output("#{bin}/havener events 2>&1", 1)
  end
end
