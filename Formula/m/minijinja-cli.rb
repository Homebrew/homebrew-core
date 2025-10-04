class MinijinjaCli < Formula
  desc "Render Jinja2 templates directly from the command-line to stdout"
  homepage "https://docs.rs/minijinja/latest/minijinja/"
  url "https://github.com/mitsuhiko/minijinja/archive/refs/tags/2.12.0.tar.gz"
  sha256 "b70d30f5165527d5b67712bf01226fb6add6b8ec38ada194c56f28889a4c6abe"
  license "Apache-2.0"
  head "https://github.com/mitsuhiko/minijinja.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1db406c1c6ba2bc13902d23ede762e36e580dcf0a8b603c6f142c28b53f2bc1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "995b6b24688b70df80180cd10ead0011af56a88f7f17c0692a7e395a39bbff94"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1857a1dfcdd55c93a7fc28b8ae821b5dd72db070e11bf84574258996ae2ab7d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "340b6e423c1dc27ffc8e2341ff5924bd7a187c497723c62b2af477f8b39876b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "29482097f68789845f57748c22adee2b13f082dad19f1000da0af220a34cb1c8"
    sha256 cellar: :any_skip_relocation, ventura:       "70aafcf5d706b94e0c785c0a4a8eff06964f15404f203d697e77d2346717e8a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6f4fae17c5aef051da449b9f13c873f1818802f0f0a88a750dfe6c28c38a1d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7db517fda45e83d72de6c37458860520651b67d12538613d8fe0d92f236f6889"
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
