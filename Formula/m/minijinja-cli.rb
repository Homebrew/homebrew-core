class MinijinjaCli < Formula
  desc "Render Jinja2 templates directly from the command-line to stdout"
  homepage "https://docs.rs/minijinja/latest/minijinja/"
  url "https://github.com/mitsuhiko/minijinja/archive/refs/tags/2.20.0.tar.gz"
  sha256 "2cde511df6486d8c2bda050d3f26c504796448a15e7ea50ede2ab75373129430"
  license "Apache-2.0"
  head "https://github.com/mitsuhiko/minijinja.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ec8b6cd97e415c29eac5501836d2163e228bdff7faeba1694cadf73c12e3ce55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "253e9a9696b607ce503a6835219ec4ebe5583f894f719e846f15f3be38528463"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0573222f34f8326b3da019da1d9d895b9b53082d4333843399bd63f4ee712451"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1b2f6f204d1a8fa0246baa7da825c73e87650fc6dd0a68785c430558fa99ffd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "289e080d654554316c80db3efe753c122d6d29fc98331c13c3db97b3c84c14a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "563e8af604e062db10a2be788972eb050188000f308b0c3569cc254ef1801f1a"
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
