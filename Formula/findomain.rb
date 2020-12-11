class Findomain < Formula
  desc "Cross-platform subdomain enumerator"
  homepage "https://github.com/Edu4rdSHL/findomain"
  url "https://github.com/Edu4rdSHL/findomain/archive/2.1.5.tar.gz"
  sha256 "31182a63f2d2002e5dc99e8f809157c18e660a9964cbbc9faa249e131493c635"
  license "GPL-3.0-or-later"

  bottle do
    cellar :any_skip_relocation
    sha256 "738cfda36178883eb8083d531385150cba5213c1831af275121d4fe7f6b3d9fb" => :catalina
    sha256 "0165c9c1915bc01105c4df30f8883e16ede8d48d49bc98735e85da90247864be" => :mojave
    sha256 "3470286233010baffcff04f55ef25d5bc8662649a14e17832c69fc307857b84a" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Good luck Hax0r", shell_output("#{bin}/findomain -t brew.sh")
  end
end
