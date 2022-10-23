class Onefetch < Formula
  desc "Command-line Git information tool"
  homepage "https://github.com/o2sh/onefetch"
  url "https://github.com/o2sh/onefetch/archive/v2.13.1.tar.gz"
  sha256 "551b59102965e968e24c41de6bb6cb5c1f062d94ada6baac77a54c2ec412cb2f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "348c870319a703d38d860c14928ebb7ed0f1a8836ad1258aed5e656b605839aa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "65ab5ebc6bc64720d0cf12f67f71993ca6c09da829776558141dbb537e85063d"
    sha256 cellar: :any_skip_relocation, monterey:       "0a69466dbb22a9be1559015543933453376a73ee381398bdef0af7d4bb633595"
    sha256 cellar: :any_skip_relocation, big_sur:        "cbebf157ad5c41f72445f9c2c7ef71926be62d64921dddca4ae61b50a73d10c7"
    sha256 cellar: :any_skip_relocation, catalina:       "09a39936c22bd2dc3524dd62268d2d049eaa38f73bdc7c05f7b1437be3c490d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95e1fafa426f99717f39e01515a4af8bf4e20235be581fd527ba35d17e1991c6"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/onefetch", "--help"
    assert_match "onefetch " + version.to_s, shell_output("#{bin}/onefetch -V").chomp

    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    system "git", "remote", "add", "origin", "https://github.com/user/repo.git"
    system "echo \"puts 'Hello, world'\" > main.rb && git add main.rb && git commit -m \"First commit\""
    assert_match("Ruby (100.0 %)", shell_output("#{bin}/onefetch").chomp)
  end
end
