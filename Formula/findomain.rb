class Findomain < Formula
  desc "Cross-platform subdomain enumerator"
  homepage "https://github.com/Findomain/findomain"
  url "https://github.com/Findomain/findomain/archive/3.1.0.tar.gz"
  sha256 "4744fbf110ba12b1eb19ff0956ad168c52ed9c7449870c4a7804c52a1c318c73"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c40ff93f6f0d2b122c6257bc07df0d428134ea760b4b8340e150b448159372f8"
    sha256 cellar: :any_skip_relocation, big_sur:       "8150740df92532a8bfb3355ce75256809cc35cdd49483fc2674d6f1bca79586c"
    sha256 cellar: :any_skip_relocation, catalina:      "cff5c8e2f5cf7751a0c7179aef7f796f8624463039f94e8e0c8e23b57873878d"
    sha256 cellar: :any_skip_relocation, mojave:        "f920e754023c4aa8a41c3894731f327c6c7b4e4e65bbf54454507f555ca7ff39"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Good luck Hax0r", shell_output("#{bin}/findomain -t brew.sh")
  end
end
