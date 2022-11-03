class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v2.19.0.tar.gz"
  sha256 "522aeaa5e1ed885d89cf44fe8e1c84da6a372046d4e173a5cd290821ac5afdc8"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "63af5a91fdef4ce52e9e43b66258a9612dbd0d73c188a8a278b5a3f24c2d2d13"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "110facf8dafaa1a7205d2d3b923d0543e895b1651a87778113ff32f7d995a40c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c34c1bb03866232dde5adc27ea464636ead19dae032ecfed52675b8f5e4fcd8e"
    sha256 cellar: :any_skip_relocation, monterey:       "5dc4545dfb08f83aa474d0bb1797bd6ca1dc8687793c0a9c93eab784f582bd82"
    sha256 cellar: :any_skip_relocation, big_sur:        "c84363f18557e1ce87548fee860b089ecf6527a4413145b078c624006c4dcc17"
    sha256 cellar: :any_skip_relocation, catalina:       "57b9cdc303a86981efc8a88ff9a36d95a0da8aeb2b7a6bf90a4098945b0fa6ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ad1cb7e62ef6b9291cb277582717bccefea39e382b1c033a3b7d74cf548bca4"
  end

  depends_on "go" => :build

  def install
    with_env(
      "GH_VERSION" => version.to_s,
      "GO_LDFLAGS" => "-s -w -X main.updaterEnabled=cli/cli",
    ) do
      system "make", "bin/gh", "manpages"
    end
    bin.install "bin/gh"
    man1.install Dir["share/man/man1/gh*.1"]
    generate_completions_from_executable(bin/"gh", "completion", "-s")
  end

  test do
    assert_match "gh version #{version}", shell_output("#{bin}/gh --version")
    assert_match "Work with GitHub issues", shell_output("#{bin}/gh issue 2>&1")
    assert_match "Work with GitHub pull requests", shell_output("#{bin}/gh pr 2>&1")
  end
end
