class Navi < Formula
  desc "Interactive cheatsheet tool for the command-line"
  homepage "https://github.com/denisidoro/navi"
  url "https://github.com/denisidoro/navi/archive/refs/tags/v2.22.1.tar.gz"
  sha256 "a728ad6b6e18abe27ca2190983bedca719e46462007e61bedbc50fc9d15b89a5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11fb063a8feb7479c1c8e027b418fe4eeb2ce0c6533e9e1fcb8f0bb6b3e51184"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b298bac9d3585536f184768eaf6a6553d66c4ba8ffcca2a477e5d5dc8cb95d9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "00928858c1656fb7d2c4c914537d280b519705f64c363c8e2f8be2834cb2348e"
    sha256 cellar: :any_skip_relocation, ventura:        "8c80e5544f78032c082085ec62c684f118d1eedeaa8ed221a29de30fb9622638"
    sha256 cellar: :any_skip_relocation, monterey:       "521bfbff2d18d71ffbad13f779db5fdd3c7845979056b3b971764b75666cc4be"
    sha256 cellar: :any_skip_relocation, big_sur:        "e7365c1f4a1aeed3d144c6e4ef71deb5a0d0e5339338cf62adedb205098f0c81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6dcaf2e3ed8224a9f16d1366c2718829d473ca7829ff1682a3a965883b6807ef"
  end

  depends_on "rust" => :build
  depends_on "fzf"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "navi " + version, shell_output("#{bin}/navi --version")
    (testpath/"cheats/test.cheat").write "% test\n\n# foo\necho bar\n\n# lorem\necho ipsum\n"
    assert_match "bar",
        shell_output("export RUST_BACKTRACE=1; #{bin}/navi --path #{testpath}/cheats --query foo --best-match")
  end
end
