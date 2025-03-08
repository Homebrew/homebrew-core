class Delve < Formula
  desc "Debugger for the Go programming language"
  homepage "https://github.com/go-delve/delve"
  url "https://github.com/go-delve/delve/archive/refs/tags/v1.24.1.tar.gz"
  sha256 "1bc657e7e429c4917b6cae562356bf6da6cebcd4fde35f236e8174743d9e1eb8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6417c41adda25dcf9e5cc7bc5ea743f025576dda244ca3435b4893143ba8a751"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6417c41adda25dcf9e5cc7bc5ea743f025576dda244ca3435b4893143ba8a751"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6417c41adda25dcf9e5cc7bc5ea743f025576dda244ca3435b4893143ba8a751"
    sha256 cellar: :any_skip_relocation, sonoma:        "4639c796ade719466a13649561648a1eaa9b6e78118f2463d7711b189e0672c8"
    sha256 cellar: :any_skip_relocation, ventura:       "4639c796ade719466a13649561648a1eaa9b6e78118f2463d7711b189e0672c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c039c306f27da9fd316b2e5089dfccf201f68fb10a72329f0f9fb9eaf38b303"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"dlv"), "./cmd/dlv"

    generate_completions_from_executable(bin/"dlv", "completion")
  end

  test do
    assert_match(/^Version: #{version}$/, shell_output("#{bin}/dlv version"))
  end
end
