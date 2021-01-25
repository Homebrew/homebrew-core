class Dstask < Formula
  desc "Git-powered personal task tracker"
  homepage "https://github.com/naggie/dstask"
  url "https://github.com/naggie/dstask/archive/v0.23.2.tar.gz"
  sha256 "30665d3f0f1e268af6eff681e331557f56273bf6ac7491b489c50725b55ef293"
  license "MIT"
  head "https://github.com/naggie/dstask.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9233f42a2b657925665a83231c00d832735789c79012efc7bd3a601a7aebbed6" => :big_sur
    sha256 "49efae7064d804f07689b8baaa986964c3ffd64c1d0f787c7935ebb2c5f7e37b" => :arm64_big_sur
    sha256 "189657a206ca8f04468f979514fc68d16d4aafe00e87f7d7222f78343c75e32a" => :catalina
    sha256 "88a62635abf2495b5e2be777b4bedb22b3df04eb90c64373a768bf5ff49e5ba9" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "mod", "vendor"
    system "make", "dist/dstask"
    bin.install Dir["dist/*"]
  end

  test do
    mkdir ".dstask" do
      system "git", "init"
      system "git", "config", "user.name", "BrewTestBot"
      system "git", "config", "user.email", "BrewTestBot@test.com"
    end

    system bin/"dstask", "add", "Brew the brew"
    system bin/"dstask", "start", "1"
    output = shell_output("#{bin}/dstask show-active")
    assert_match "Brew the brew", output
    system bin/"dstask", "done"
  end
end
