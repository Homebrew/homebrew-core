class Findomain < Formula
  desc "Cross-platform subdomain enumerator"
  homepage "https://github.com/Findomain/Findomain"
  url "https://github.com/Findomain/Findomain/archive/7.0.0.tar.gz"
  sha256 "94d2949972aba3a0c4d85f1ba2dd8bf818ea193fd058634aaa3bdc8e911cb838"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee471c4b6bb3bb464614cee3ea544fc6bbd18e9a2b7b7214224b8e9f0dc346ea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "766fe8bd31632ba849b175119a94b20d8d79b6fa73c5ed57a11d55638e646a58"
    sha256 cellar: :any_skip_relocation, monterey:       "9530d6aecdf978dad5f5891643e6c223b43c58a6fa0dfb511cadfb8e6c447353"
    sha256 cellar: :any_skip_relocation, big_sur:        "c08f04183385f6300019503704933a999100b6cf698cd49d12336409b059658f"
    sha256 cellar: :any_skip_relocation, catalina:       "b4d5868242a171559fbe6e57d802e47015f2372f9777954c5fe03c3afe0efcfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af915b7ac7691d6158332f62ff136f894c4205f6a8dd3d995c6beb96c72fe8bf"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Good luck Hax0r", shell_output("#{bin}/findomain -t brew.sh")
  end
end
