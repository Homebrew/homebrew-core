class MinijinjaCli < Formula
  desc "Render Jinja2 templates directly from the command-line to stdout"
  homepage "https://docs.rs/minijinja/latest/minijinja/"
  url "https://github.com/mitsuhiko/minijinja/archive/refs/tags/2.15.1.tar.gz"
  sha256 "c6000abed226a1d46804ee54b49d13c7b2b2609e6820b483eac396039897748a"
  license "Apache-2.0"
  head "https://github.com/mitsuhiko/minijinja.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b18e25460a1dbe263d1451ebd7efa801e8d72884c782d8cf182d71fa0b6d2945"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20e8ea916ff9ce4a7cb4fde9a6cf99f92d1f07194894dd1316ae747572abe270"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6239e04af2dc4ce45fa176958efededb6508dde12a349bb852dd83106458b0b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "df3f05c58f665b27ff2d46ff8456bb6fdd0f2c7632d5c655f6cd23a58d504d67"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a89481772d7847d623bff14dbc6244914dda6bc53b30bc783c9c0c72921c54f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cd116a2f4149ba9f67050d59fdcde0d0c19462fd3fb38e1e5c519d34bea5006"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "minijinja-cli")

    generate_completions_from_executable(bin/"minijinja-cli", "--generate-completion")
  end

  test do
    (testpath/"test.jinja").write <<~EOS
      Hello {{ name }}
    EOS

    assert_equal "Hello Homebrew\n", shell_output("#{bin}/minijinja-cli test.jinja --define name=Homebrew")
  end
end
