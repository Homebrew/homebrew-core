class Acme < Formula
  desc "Crossassembler for multiple environments"
  homepage "https://sourceforge.net/projects/acme-crossass/"
  url "https://svn.code.sf.net/p/acme-crossass/code-0/trunk", revision: "266"
  version "0.97"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://sourceforge.net/p/acme-crossass/code-0/HEAD/tree/trunk/docs/Changes.txt?format=raw"
    regex(/New in release v?(\d+(?:\.\d+)+)/i)
    strategy :page_match
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "f603308c41ccb1f3b81bef2ffccc7a3ec09b797133abb5d41f9574a95411f73b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "789ffc7764ec07db6142518896bff4aa1940980929b977fabb084ef12d1d4ea7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2c48aa0b38e6597799d22ec3c0ad8c8868c753918a92adb4f60ab7f9eabe945b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f8b137715ebc611f81b2e49445396488a26a0240a7e9fe24f8fb897aecf964f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c56301699b1c2419655c5fac5e5a1c16767729d7a4afa9560231ecdd60972d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eed2df7b934a52ca875e02a7b89588ac602cfa0cfbde0e795bbcdaff72bb5201"
    sha256 cellar: :any_skip_relocation, sonoma:         "9075f4b6b9cc0869c5a800d6b35aaa92f66f6964495545ae7a4f742fd3d50940"
    sha256 cellar: :any_skip_relocation, ventura:        "4de66d662e3631ae88f197b7b28045407b929d05d5d844cc7f3569696df7078a"
    sha256 cellar: :any_skip_relocation, monterey:       "057df491fd1784cad46df8397ddd2cb972c256d094b5849731899bd03163184a"
    sha256 cellar: :any_skip_relocation, big_sur:        "7890b8c1a32b202ab913553d534db373de3d61bb274a564fb9304cd4de043736"
    sha256 cellar: :any_skip_relocation, catalina:       "54080f9a08a3f958c5a024fd536c2308c392521a4a4092afb115f368b3256fd2"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "743dda54569b1514edf7632a1d62b7f93b44324cdb91d2520a10f27edd3236e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fcb14a109abee4d1af24a79bc4991a851a6b1b75fd64999e815715fc54a4c834"
  end

  def install
    system "make", "-C", "src", "install", "BINDIR=#{bin}"
    doc.install Dir["docs/*"]
  end

  test do
    path = testpath/"a.asm"
    path.write <<~ASM
      !to "a.out", cbm
      * = $c000
      jmp $fce2
    ASM

    system bin/"acme", path
    code = File.open(testpath/"a.out", "rb") { |f| f.read.unpack("C*") }
    assert_equal [0x00, 0xc0, 0x4c, 0xe2, 0xfc], code
  end
end
