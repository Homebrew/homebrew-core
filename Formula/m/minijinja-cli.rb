class MinijinjaCli < Formula
  desc "Render Jinja2 templates directly from the command-line to stdout"
  homepage "https://docs.rs/minijinja/latest/minijinja/"
  url "https://github.com/mitsuhiko/minijinja/archive/refs/tags/2.10.2.tar.gz"
  sha256 "d3d87f55bc6c36345602023946ddc1c68d345a51f5f1e8891176efc2dc0e7ec2"
  license "Apache-2.0"
  head "https://github.com/mitsuhiko/minijinja.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fdab575674a5aba3287226ea984f48f5f726ff1a0b9e0b4f9bf7f89859577d15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ebdba325ebd5763d2582a2f8bf37617f3480a474c593e34d44c2535c4645558c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f81b9d6b7c267b0f19a82bb18fd2819be637d7732fa6e9a78c16b708d298209d"
    sha256 cellar: :any_skip_relocation, sonoma:        "41d21db20b1c5814f4fa9f414180a667a53f56eaea3ddbca4cb66bfa96a23ba5"
    sha256 cellar: :any_skip_relocation, ventura:       "c45256f4dc5780cca1800b1f31236350c7f7bb1511cee70cd644741253452478"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef6f8c2a3020b5099850488a2faf33845c70738e67d3ff83e5ccfb235ca96bc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82d050d407ccece77126f7fcdc76f7df392244757fdd7cba1f6bc5729a5174ab"
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
