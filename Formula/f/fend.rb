class Fend < Formula
  desc "Arbitrary-precision unit-aware calculator"
  homepage "https://printfn.github.io/fend"
  url "https://github.com/printfn/fend/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "1d3e37c2688846539b1666a924fdee5bdf60f54d94c8be6ccfd4364267f13af0"
  license "GPL-3.0-or-later"
  head "https://github.com/printfn/fend.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "76b8eb374d5ea960d30d06bfdf1a1d79ffa15639ccbf528a2afed31a919970a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b529f5c885533cf70acc2facf0c5c4a0835ca605f7125e4ea0eda0f01d63eced"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9cf77887d9c5cd10b59e4ae86f070e70306f83700c99aef5d3062c46bd27505"
    sha256 cellar: :any_skip_relocation, sonoma:         "7b876ee7eae2d94218eb7ffb3050a51a660d7f65aaaa7e5714baefce4159afb7"
    sha256 cellar: :any_skip_relocation, ventura:        "e8f97baca224a166ab25d6f2ec30d30cc8162829653251aa74b7c8d1615ff0df"
    sha256 cellar: :any_skip_relocation, monterey:       "e4e6fa3c427a9d01465e1cfc16a7c75f7da89ce4ce4532938acd23737c35faf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2f9554cfbaeb36075c1908e5f08ded78e375a6430ec487799909775677639a3"
  end

  depends_on "pandoc" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    system "./documentation/build.sh"
    man1.install "documentation/fend.1"
  end

  test do
    assert_equal "1000 m", shell_output("#{bin}/fend 1 km to m").strip
  end
end
