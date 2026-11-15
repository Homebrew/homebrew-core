class Gat < Formula
  desc "Cat alternative written in Go"
  homepage "https://github.com/koki-develop/gat"
  url "https://github.com/koki-develop/gat/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "424ad788c91081fe5db432f99d108802bb96ef5688b0ccb263cc4ca673efb155"
  license "MIT"
  head "https://github.com/koki-develop/gat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "10d8bac08f836a29c56de07a5028fe9a9e2b44da111b7b290ee22699e8f3ab18"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "10d8bac08f836a29c56de07a5028fe9a9e2b44da111b7b290ee22699e8f3ab18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "10d8bac08f836a29c56de07a5028fe9a9e2b44da111b7b290ee22699e8f3ab18"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a9e38e691aaea720f6ef43ab0b648b5f07dd463fea03704a82070fdacf58d513"
    sha256 cellar: :any,                 x86_64_linux:      "52c8726fd21488129ece31f50a4cd8d1cd91001b452ce95e6dfdd0e5ff426063"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X github.com/koki-develop/gat/cmd.version=v#{version}")
  end

  test do
    (testpath/"test.sh").write 'echo "hello gat"'

    assert_equal \
      "\e[38;5;231mecho\e[0m\e[38;5;231m \e[0m\e[38;5;186m\"hello gat\"\e[0m",
      shell_output("#{bin}/gat --force-color test.sh")
    assert_match version.to_s, shell_output("#{bin}/gat --version")
  end
end
