class Dstask < Formula
  desc "Git-powered personal task tracker"
  homepage "https://github.com/naggie/dstask"
  url "https://github.com/naggie/dstask/archive/v0.24.1.tar.gz"
  sha256 "35d46ade97f7b68e2bfb719b8bdb0db65e4b66b97e368849ecdecab1d58ef3d0"
  license "MIT"
  head "https://github.com/naggie/dstask.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e3052c41bef447b00c185cd178e1c075612a489af4b7f2762db39ff44a0376e3"
    sha256 cellar: :any_skip_relocation, big_sur:       "b3ff60735540a9d39f2e774a3086351e51c825e33c870983893b12dcc658c688"
    sha256 cellar: :any_skip_relocation, catalina:      "0a6dda79900bb4ce66e3d00c62c725d0c3617ac8fee905670916ff45ef49993b"
    sha256 cellar: :any_skip_relocation, mojave:        "3e64448e02e05ab6266650a98f6be252fb21389b217bd70e6a7d910290b1db21"
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
    system bin/"dstask", "done", "1"
  end
end
