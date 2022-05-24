class Genact < Formula
  desc "Nonsense activity generator"
  homepage "https://github.com/svenstaro/genact"
  url "https://github.com/svenstaro/genact/archive/v0.12.0.tar.gz"
  sha256 "fbbbcf5e65b370fde6765a2257c6d2f12cb9568bdce785b0f548c2be28d08cd7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5f3dccf21c352c8e6f3b1b581c876ef0ac6db01e813ee32ac98bf03f98b0598"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "60deedd7d98698e495ed8961c6610c8c3c10bc3de77892400751e8b530a84400"
    sha256 cellar: :any_skip_relocation, monterey:       "4df62a1b1c45fa7ecf3cfb5a4a53ca929de76e473d9c9782dd483aef137317d0"
    sha256 cellar: :any_skip_relocation, big_sur:        "cef5aeb816501bcd6faf9d2a6c5a951dbf61ad4587695aa806c23a03fcdd01dd"
    sha256 cellar: :any_skip_relocation, catalina:       "d8c65bfcb7e9f9bfe0dc740d9ce2ba8ccbb1b252c3f6badcdb6c83b624e6dd7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3dd877446bcb3ada800e4799071deefab88a114104682387bb08f33d85e7231"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Available modules:", shell_output("#{bin}/genact --list-modules")
  end
end
