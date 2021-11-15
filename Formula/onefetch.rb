class Onefetch < Formula
  desc "Git repository summary on your terminal"
  homepage "https://github.com/o2sh/onefetch"
  url "https://github.com/o2sh/onefetch/archive/v2.10.2.tar.gz"
  sha256 "6e4d4effcd4fd94ce21625a5e32da5da6446c8874200e40dd791e623b7aff7bb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ac61a91d933db279540829d7a50eedb3e80b2d93aca42871a96c209defbc400"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "058c97bfad7e60faeed7a6335ea8e9896f90f7a34fd0a17726d455643b16c0d5"
    sha256 cellar: :any_skip_relocation, monterey:       "1a6195c8a955806f227a0280f386a82b743214c69a2659b4713e75a39760b5cd"
    sha256 cellar: :any_skip_relocation, big_sur:        "3c478262017e9e019e0c2c42f8cef1be31ff8d336afdcf77476d0c72afe43810"
    sha256 cellar: :any_skip_relocation, catalina:       "a79b95318ad14dbea71093af6dce7c2f5c945b2bfc6c5b44e2f0b54805e90d4f"
    sha256 cellar: :any_skip_relocation, mojave:         "af8f091e15c4ffc30bd74e55b23710eabedd6f3217a7eb4afb5fc261687de42d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de7373759f68650076a23bf98cafc9910f22362b84fb2f001aca4d7c6e47383c"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/onefetch", "--help"
    assert_match "onefetch " + version.to_s, shell_output("#{bin}/onefetch -V").chomp

    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    system "echo \"puts 'Hello, world'\" > main.rb && git add main.rb && git commit -m \"First commit\""
    assert_match(/Language:.*Ruby/, shell_output("#{bin}/onefetch").chomp)
  end
end
