class Dust < Formula
  desc "More intuitive version of du in rust"
  homepage "https://github.com/bootandy/dust"
  url "https://github.com/bootandy/dust/archive/v0.5.4.tar.gz"
  sha256 "395f0d5f44d5000468dc51a195e4b8e8c0b710a1c75956fb1f9ad08f2fbbc935"
  license "Apache-2.0"
  head "https://github.com/bootandy/dust.git"

  livecheck do
    url :head
    regex(/v([\d.]+)/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "d1b5422255a774bfc2a582936c2a639e70167a1a6ae01cc2a99d9d3bded9d3fb" => :big_sur
    sha256 "63975da52bf489fa48faf28948811662e212ba34bd3eec9e46326ef75c90d3aa" => :arm64_big_sur
    sha256 "7b30dd40fba19a354809b0d311afb061b3d67134a4e8dc522911240fc04f1c56" => :catalina
    sha256 "9a20691424cccdb57170661480740191517a617d2a1a079d29411fd376f4f78a" => :mojave
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match /\d+.+?\./, shell_output("#{bin}/dust -n 1")
  end
end
