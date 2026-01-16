class Carapace < Formula
  desc "Multi-shell multi-command argument completer"
  homepage "https://carapace.sh"
  url "https://github.com/carapace-sh/carapace-bin/archive/refs/tags/v1.5.7.tar.gz"
  sha256 "288f5629d9d842366089c75c388566b62bd452e5d2652384daeb419b134ec354"
  license "MIT"
  head "https://github.com/carapace-sh/carapace-bin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e4f8d3c63ef688183978207e4dfa9728aa3bbb161b9e9c53d77c5e684f60202"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e4f8d3c63ef688183978207e4dfa9728aa3bbb161b9e9c53d77c5e684f60202"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e4f8d3c63ef688183978207e4dfa9728aa3bbb161b9e9c53d77c5e684f60202"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d30e0ae6ab0a5779455a88aa08ff373f15142f2bd6c4a4633e4e4a06a6043a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89f90ff96fc74c2eccdc4aec2910cc39f382bf082861a2aa8c14d27a20f4ff51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4dd6b80e7a62bdd49151c9221a6fc4f3ee350f85178006800fc69828300cb880"
  end

  depends_on "go" => :build

  def install
    system "go", "generate", "./..."
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "release"), "./cmd/carapace"

    generate_completions_from_executable(bin/"carapace", "carapace")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/carapace --version 2>&1")

    system bin/"carapace", "--list"
    system bin/"carapace", "--macro", "color.HexColors"
  end
end
