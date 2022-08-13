class Prr < Formula
  desc "Mailing list style code reviews for github"
  homepage "https://github.com/danobi/prr"
  url "https://github.com/danobi/prr/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "249a50487af9e947cea12597e6024041ed21bb4ebe6214d147e0750508e134c3"
  license "GPL-2.0-only"
  head "https://github.com/danobi/prr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c6547be0918cb4bf48a65ebabe4676f195054b55a483f62f09f012f759c428c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9c983c6f377274015d35e6e5d1c6293c2181feebe2f00d57135dec566dd4ba7c"
    sha256 cellar: :any_skip_relocation, monterey:       "8b0e195a99a1e888d178e7fa2ff524113bdb419c213f1d8afe3dc764e217f3fa"
    sha256 cellar: :any_skip_relocation, big_sur:        "5d3d253a2498a52df17d0c0fb83daf024ef5f9199727d9cb83f27551e309d01c"
    sha256 cellar: :any_skip_relocation, catalina:       "7604a13cf21a13c66dceb07bb3b6d7fcb5c6501a8c602c72543525c08e650e56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ecaa3243521d2b217fdfdf2c6bfc3e9609f26131aaee4d0aec8a77577403612"
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
