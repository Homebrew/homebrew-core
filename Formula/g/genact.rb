class Genact < Formula
  desc "Nonsense activity generator"
  homepage "https://github.com/svenstaro/genact"
  url "https://github.com/svenstaro/genact/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "cd8c9a6ba23ca4634a90041454bcd662289470878276d327efb555255e60e597"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa35be5ba8acfd172d00b03084f4a6c722dfc700a2351829bd1dfbbe2313ee2d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b07bd7c1a261206122acc3d6a82be2335b49e82e2a42850f40ac36ecfddd616"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c8f4bbdcc855554b5e26ecd4e8aa65e0c22ae87951d1c4bb7b01d27010b5258"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4bc049250f48520465874d13b6860cb320160cac63a8b82f937caa4f91b9da4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b18deb4f8a5c030be39ac49d2940870ba820c7b3187740cb508a3537251d5c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd7b9af010187e5d98ae520f153ecb19dda279da581999772782d07a319fa8f1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"genact", "--print-completions")
  end

  test do
    assert_match "Available modules:", shell_output("#{bin}/genact --list-modules")
  end
end
