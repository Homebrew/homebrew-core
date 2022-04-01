class Findomain < Formula
  desc "Cross-platform subdomain enumerator"
  homepage "https://github.com/Findomain/Findomain"
  url "https://github.com/Findomain/Findomain/archive/7.2.0.tar.gz"
  sha256 "cbc765637c685392adab117dbcd94a4932cd6488e7adf8058e893077179f80e7"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d89f6b327c16485899436d9b78e7373383978cc9926a085fb8de31a756efcaaa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "40249001634a1c5f92d06300809a32ac6364adb61249f7afe7df9a1bbe62811f"
    sha256 cellar: :any_skip_relocation, monterey:       "a7c771043db5d0c3889247fac2083d707bae18f08351b2594f7b1cd2255f8c77"
    sha256 cellar: :any_skip_relocation, big_sur:        "017868b5f0ada7fd99c3280408416e00c5f8c3eab865a922722032eb944bc923"
    sha256 cellar: :any_skip_relocation, catalina:       "342223805069954ce9b102ed0f99f136bc395ee4f06d4808248a17c3de5c0641"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e9ed1f0ba7e68d608a1906e96baaaa702a86861f86a041a9a660a8cf399497a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Good luck Hax0r", shell_output("#{bin}/findomain -t brew.sh")
  end
end
