class MinijinjaCli < Formula
  desc "Render Jinja2 templates directly from the command-line to stdout"
  homepage "https://docs.rs/minijinja/latest/minijinja/"
  url "https://github.com/mitsuhiko/minijinja/archive/refs/tags/3.1.0.tar.gz"
  sha256 "6eddec4714167d07dd29a68c7d1489777e81f6cbc7f164710607b1e9a87837bc"
  license "Apache-2.0"
  head "https://github.com/mitsuhiko/minijinja.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2aa7b0438902279bb09b661803ad439a88f58e03353cef17029551e4fab71dae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0964245cd25bb40071055e582befe0dd8825c580eb1126cc38fb0272c3609c59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "db642e3e095fb77a6bdb41ef63d68abc1a3596e7242156a6733d576efc6dbc86"
    sha256 cellar: :any,                 arm64_linux:       "75128ee7a2612bea12e7b0a978b90e6fb3900e1b00a295594318ca2a791634c7"
    sha256 cellar: :any,                 x86_64_linux:      "12eea37c955e385e9d48f6fa9f8537ce174d2885df230c90af59062b2caa6ccd"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "minijinja-cli")

    generate_completions_from_executable(bin/"minijinja-cli", "--generate-completion")
  end

  test do
    (testpath/"test.jinja").write <<~JINJA
      Hello {{ name }}
    JINJA

    assert_equal "Hello Homebrew\n", shell_output("#{bin}/minijinja-cli test.jinja --define name=Homebrew")
  end
end
