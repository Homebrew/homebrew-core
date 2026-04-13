class Jsongrep < Formula
  desc "Query tool for JSON, YAML, TOML, and other structured formats"
  homepage "https://github.com/micahkepe/jsongrep"
  url "https://github.com/micahkepe/jsongrep/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "f728f3a5ed876053a85ff095f7d03073d5a43ce9ece3134b63539bdaa711aff7"
  license "MIT"
  head "https://github.com/micahkepe/jsongrep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "034ea6f33f610aa1020bfb2d43da8d75bf713151a4569540d58ddd4d230c18dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b10860f29e0f0754a412ebb8a4cc1f18fc797f70da9cc4f1ce78f0401da50232"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef101dd75de29b8a6f3eae43627200d288a130be04df054461d56de785dde78c"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1e923a7243660a8503f302cd44f21c3e17c7ba1c8829697321302f03affd369"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d64e0a2e24e5c742e81d48a646bc11e5654f4b06030134398eccd7ba93d28a27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6f81909e53d359960648806705de253d94e1b7fbf672ed37838538aaa7116f2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"jg", "generate", "shell", shells: [:bash, :zsh, :fish, :pwsh])
    system bin/"jg", "generate", "man", "--output-dir", man1
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jg --version")

    assert_equal "2\n", pipe_output("#{bin}/jg -F bar", '{"foo":1, "bar":2}')
  end
end
