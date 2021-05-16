class Findomain < Formula
  desc "Cross-platform subdomain enumerator"
  homepage "https://github.com/Findomain/findomain"
  url "https://github.com/Edu4rdSHL/findomain/archive/4.3.0.tar.gz"
  sha256 "e0a7cf999ee7b467641a4b2fe505d43679e3c0f53cde103ae0ef37e73fd20cd5"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bfb08b2c5c4295bb6533194d0095164ee33a8f8ffdeb1eed1e6a3d70a6d5817f"
    sha256 cellar: :any_skip_relocation, big_sur:       "5e29da4081f50cd973dd0bb93758a25173b7140f156b4f74369f4c5fb851cd92"
    sha256 cellar: :any_skip_relocation, catalina:      "6953700516214886644476c9a16c23f94442c59bdc120bfa1b1f0a147d87cd81"
    sha256 cellar: :any_skip_relocation, mojave:        "5182efdc8c2306b769e8422b236507e4ebc61d6ade664ea7ffc7da26c0037368"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Good luck Hax0r", shell_output("#{bin}/findomain -t brew.sh")
  end
end
