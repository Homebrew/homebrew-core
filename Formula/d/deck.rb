class Deck < Formula
  desc "Creates slide deck using Markdown and Google Slides"
  homepage "https://github.com/k1LoW/deck"
  url "https://github.com/k1LoW/deck/archive/refs/tags/v1.24.1.tar.gz"
  sha256 "dd5d79049bb9b2f9d1d670b6a7f4ab7d4630e26a98c730a7ab4297382d9466fe"
  license "MIT"
  head "https://github.com/k1LoW/deck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "04c7204dfe0106209c65cca20ca09ab64af186da68a965376de30642b929879c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04c7204dfe0106209c65cca20ca09ab64af186da68a965376de30642b929879c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04c7204dfe0106209c65cca20ca09ab64af186da68a965376de30642b929879c"
    sha256 cellar: :any_skip_relocation, sonoma:        "89f67c553ba153f938607fe7831067dd0a2acfbd40ef83fdd201ea493d928e3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "599c5057efbf118001db679c2cf20fb703e0ecbfa7bd787799ab47ccbab53929"
    sha256 cellar: :any,                 x86_64_linux:  "b2144a7bde586b709ee88761092f43a99a5ed1f334a46eafa85b56ddfe274218"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/deck"

    generate_completions_from_executable(bin/"deck", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/deck --version")
    assert_match "presentation ID is required", shell_output("#{bin}/deck export 2>&1", 1)
  end
end
