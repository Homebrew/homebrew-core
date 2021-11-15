class Nsh < Formula
  desc "Fish-like, POSIX-compatible shell"
  homepage "https://github.com/nuta/nsh"
  url "https://github.com/nuta/nsh/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "b0c656e194e2d3fe31dc1c6ee15fd5808db3b2428d79adf786c6900ebbba0849"
  license any_of: ["CC0-1.0", "MIT"]
  head "https://github.com/nuta/nsh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1d4aaa96c329882423ba9bef1a834e9d0e7f12eebd786e7a229461113a7de99"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9025b069d64133a40f5e1c5f1ad35178ef47a601d321da10749323dc54f48f3c"
    sha256 cellar: :any_skip_relocation, monterey:       "6deefb05e0d22f1597101e1703aadfa5a27e1ec3175037b84a5b5584b3310181"
    sha256 cellar: :any_skip_relocation, big_sur:        "8454140462f3968d3c29b64ab2248faa2fb544a491c3e3f2291da24f60801dac"
    sha256 cellar: :any_skip_relocation, catalina:       "04010c69722c2060dd83c66a1b30281014126248a4586b5c0959ff5bbfdc00e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "131188c37bdb5c53e7cdad97e1c24ae13e0ae361636a883698521bee40c699d3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_equal "hello", shell_output("#{bin}/nsh -c \"echo -n hello\"")
  end
end
