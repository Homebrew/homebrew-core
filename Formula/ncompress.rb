class Ncompress < Formula
  desc "Fast, simple LZW file compressor"
  homepage "https://github.com/vapier/ncompress"
  url "https://github.com/vapier/ncompress/archive/v4.2.4.6.tar.gz"
  sha256 "112acfc76382e7b631d6cfc8e6ff9c8fd5b3677e5d49d3d9f1657bc15ad13d13"
  license "Unlicense"
  head "https://github.com/vapier/ncompress.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "99dfe3616e05c375b6ae1763076b4e22f5ebc174871b90bce96ecfd5026a2f66" => :big_sur
    sha256 "936e3de1f5c49c55295c889acbb032d31f71d0f91cfb6f7f1b1ca0886c049c05" => :arm64_big_sur
    sha256 "fb99eafbcce7f39b4abec7c16f12fa0a78a386862e76502ebcca8103d5926111" => :catalina
    sha256 "675a940f00e11c3003ca42aa3f77bac4e853fab48d2a036cfd2bd41e24d369b7" => :mojave
  end

  keg_only :provided_by_macos

  def install
    system "make", "install", "BINDIR=#{bin}", "MANDIR=#{man1}"
  end

  test do
    Pathname.new("hello").write "Hello, world!"
    system "#{bin}/compress", "-f", "hello"
    assert_match "Hello, world!", shell_output("#{bin}/compress -cd hello.Z")
  end
end
