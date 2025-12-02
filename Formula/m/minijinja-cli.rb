class MinijinjaCli < Formula
  desc "Render Jinja2 templates directly from the command-line to stdout"
  homepage "https://docs.rs/minijinja/latest/minijinja/"
  url "https://github.com/mitsuhiko/minijinja/archive/refs/tags/2.13.0.tar.gz"
  sha256 "c5af57b4403a7283e2057efff6c90990b933d79e436f54ef88ef2bfe3f21e309"
  license "Apache-2.0"
  head "https://github.com/mitsuhiko/minijinja.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c707ab5f3536f5925d9d3f88bfdfd46d2b3671471e19aaad482594c9ecdbbe3e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ad982f858cb4a0143835366646a13671d82fcf9d2f2ef6cd00e1ce6bdc540d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6699ced2855e094789dd3e774f4e371fb348bce9aead898b417dc793700a29c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "800fce06e052bc77f3c735e89829c540bb74d17eefd2ab1a0f19897b61b624ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8930858589e6ae60c3fec65554572f4469ca3b26984802a86c57701e5fb2c60a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29eb4a3e48ffc041809713af17e816fb11c68913bc865727fbb034fab6553b1c"
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
