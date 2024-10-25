class MinijinjaCli < Formula
  desc "Render Jinja2 templates directly from the command-line to stdout"
  homepage "https://docs.rs/minijinja/latest/minijinja/"
  url "https://github.com/mitsuhiko/minijinja/archive/refs/tags/2.4.0.tar.gz"
  sha256 "28f862b3805e71bd4537637d14e5f1b0af67dae84f13851af8bc5c2e416a539a"
  license "Apache-2.0"
  head "https://github.com/mitsuhiko/minijinja.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1421a45038fdb9afd07caa3246725eae31a457dccfc539aa45ca269305c7f006"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f39c4a55ea47f3f81a7668bbc0f05da02366b9ffca972b80c3b6597f75e2b80b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bb8d85e5a0583951dc7458723aae61199b6a9ff44d8add9c8b225e094109d8e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a25f09846e9049b7434b21311ac2429155f34780f0957575ebb9767aac745e1"
    sha256 cellar: :any_skip_relocation, ventura:       "9a98186630876749742d45ea66651b271a5c2f23d507c73f10c288ffe3195b42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1dd5a7fda724a3138d24196f077f009884796d2d8f5cf080e94b3df87bce9021"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "minijinja-cli")
  end

  test do
    (testpath/"test.jinja").write <<~EOS
      Hello {{ name }}
    EOS

    assert_equal "Hello Homebrew\n", shell_output("#{bin}/minijinja-cli test.jinja --define name=Homebrew")
  end
end
