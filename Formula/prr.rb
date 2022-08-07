class Prr < Formula
  desc "Mailing list style code reviews for github"
  homepage "https://github.com/danobi/prr"
  url "https://github.com/danobi/prr/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "249a50487af9e947cea12597e6024041ed21bb4ebe6214d147e0750508e134c3"
  license "GPL-2.0-only"
  head "https://github.com/danobi/prr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59bd84af58d14624f61a14c8b3e279c55581abcd7cf8e88e5c67fea0bfd5b2a8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d1a7488e4c639a257e34823d3dc41089a911963673c3c4d67a7abd0092775c0"
    sha256 cellar: :any_skip_relocation, monterey:       "ff0387d269840c94c40e278e005503f2e1d5c686301ae91319c31b2678e1bddb"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d091440093e25e0a68163aaa3110612429a7f96d0e8de826651c2d7c6e2664a"
    sha256 cellar: :any_skip_relocation, catalina:       "1fcaaeb1c014be63ced0e6813bb3399ff0bd91314202d226b778f53cd323bd05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd206a8a29697fd10a28d666243354feb6cdaf135dd2a2be2bcfe6bad03b26f8"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Failed to read config", shell_output("#{bin}/prr get Homebrew/homebrew-core/6 2>&1", 1)
  end
end
