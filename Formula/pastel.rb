class Pastel < Formula
  desc "Command-line tool to generate, analyze, convert and manipulate colors"
  homepage "https://github.com/sharkdp/pastel"
  url "https://github.com/sharkdp/pastel/archive/v0.9.0.tar.gz"
  sha256 "473c805de42f6849a4bb14ec103ca007441f355552bdb6ebc80b60dac1f3a95d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/pastel.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c1b18789ed1303a84264ce7f255e29ad1e7dfaa823606bd268266544c02f843"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b4511db651e18bb5b23ca8343a0f7026ce70dc7417b9d64826b52b0ad6828eb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3b17baa2192e94615665aea818fe9b4ee202770e1ba66ea7b8a9e5889e278f38"
    sha256 cellar: :any_skip_relocation, ventura:        "c48281221eb773d7118183bf0fdbf23f078337b97eee1b11626d4353ac9afecd"
    sha256 cellar: :any_skip_relocation, monterey:       "3be2c4518d6cb3cda28aced6aa248ff97502ebbf856bae991d9016c950cecd21"
    sha256 cellar: :any_skip_relocation, big_sur:        "a1966d65a627a20680c20cc54fee52280c695a0314cc53c655b6e9aefb5180d4"
    sha256 cellar: :any_skip_relocation, catalina:       "13bf6e89bd6206f3e8b76eaeee9c957ae42a10647aaacb56ca2e14d693349c39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7826523f2dd332162d3226f9d3b749e67c354be885726caf9d695d62f67e8a1b"
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
