class Pastel < Formula
  desc "Command-line tool to generate, analyze, convert and manipulate colors"
  homepage "https://github.com/sharkdp/pastel"
  url "https://github.com/sharkdp/pastel/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "7848cd6d2ad8db6543b609dece7c9c28b4720c09fb13aeb204dd03d152159dd2"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/pastel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a6fff0aefd40678a727cc33286dc6574d22e859f4677b89b6d6bf11780bf46fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "846b6b902b61fdb6a487a55bca5db48281d15b2879a03c4a7c4d1734eb69785e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fbf1bcaec1cd65ba7c7572372f8572f26f9fc0a34453c200fbf9268fd72b1a61"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e77251303794e9030f01de3199335e116321aaf1160e50d0a66d5efeefb7b5e"
    sha256 cellar: :any_skip_relocation, sonoma:         "de5aa587edab2ba6677ce2b455c73ab4d29d93ec111b46e2afd7e948c6d94ec7"
    sha256 cellar: :any_skip_relocation, ventura:        "5fc7e310c200267bb1a9e1f47d14747c18a666e8137bc115a509d017e90fbdb8"
    sha256 cellar: :any_skip_relocation, monterey:       "111cb3e22a17758946cbb68cd3bdeb0a91320d680cf50eeb7b142d6030ce8c1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08561a70b60b1733f82b3ef31fe6ccf0f2934ae301f3a992b70a6d84e72076e6"
  end

  depends_on "rust" => :build

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath/"completions"

    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/pastel.bash"
    zsh_completion.install "completions/_pastel"
    fish_completion.install "completions/pastel.fish"
  end

  test do
    output = shell_output("#{bin}/pastel format hex rebeccapurple").strip

    assert_equal "#663399", output
  end
end
