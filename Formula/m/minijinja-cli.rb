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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1fc29c33a1b6118aff388dec06bc9a7edbdba62c8310db71a813b51b3e65c69f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b737c253a63a1f2258acc0fbc3d84cc557db94e0c72724e142387c59379261fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0463e5da6a79c5d64e7427ac2da271de0ffe8a67c09d8c453fdc7c5321bacb67"
    sha256 cellar: :any,                 arm64_linux:       "1a33afe53f7d5177c58c07a11e248d1046df3630272a78b3477cc135c3362002"
    sha256 cellar: :any,                 x86_64_linux:      "a424b1b61a0cae9ba7fc6ba1e95f5906f95556891b7a76b39af33d0d7a88a2c4"
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
