class Elio < Formula
  desc "Batteries-included terminal file manager with rich previews"
  homepage "https://github.com/elio-fm/elio"
  url "https://github.com/elio-fm/elio/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "e6fcdf85556b21048ea07f42057947f34af3ee7eb84136f1f0e322074d3af19c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "302d606cb87cbeb575f8987ed8d9b2a19bb01e886f2c83adb9306157609957e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bdccc79db8d1e4fdc49ac72c29e40fe751413489815e8ee356a12f52815c3881"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b704ebdddf5837196c395bcd33b97a277e25475975322098cefb3b6419393016"
    sha256 cellar: :any_skip_relocation, sonoma:        "938e4dd18e9a772cd643c6e527d945142c7d19046dc2165acc8fae2534da7f63"
    sha256 cellar: :any,                 arm64_linux:   "854615c419aee0ce9732498d12d1ecb5f2de682e2745b7e0bcd241a8a8e53e74"
    sha256 cellar: :any,                 x86_64_linux:  "e23b60298f3587c6483c173d0651c575483c57247ffb88c6dc6ab01b893c653b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    missing = testpath/"missing-directory"
    output = shell_output("#{bin}/elio #{missing} 2>&1", 1)
    assert_match "no such file or directory", output
  end
end
