class Acme < Formula
  desc "Crossassembler for multiple environments"
  homepage "https://sourceforge.net/projects/acme-crossass/"
  url "https://svn.code.sf.net/p/acme-crossass/code-0/trunk", revision: "266"
  version "0.97"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://sourceforge.net/p/acme-crossass/code-0/HEAD/tree/trunk/docs/Changes.txt?format=raw"
    strategy :page_match
    regex(/New in release v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f8b137715ebc611f81b2e49445396488a26a0240a7e9fe24f8fb897aecf964f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c56301699b1c2419655c5fac5e5a1c16767729d7a4afa9560231ecdd60972d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eed2df7b934a52ca875e02a7b89588ac602cfa0cfbde0e795bbcdaff72bb5201"
    sha256 cellar: :any_skip_relocation, ventura:        "4de66d662e3631ae88f197b7b28045407b929d05d5d844cc7f3569696df7078a"
    sha256 cellar: :any_skip_relocation, monterey:       "057df491fd1784cad46df8397ddd2cb972c256d094b5849731899bd03163184a"
    sha256 cellar: :any_skip_relocation, big_sur:        "7890b8c1a32b202ab913553d534db373de3d61bb274a564fb9304cd4de043736"
    sha256 cellar: :any_skip_relocation, catalina:       "54080f9a08a3f958c5a024fd536c2308c392521a4a4092afb115f368b3256fd2"
    sha256 cellar: :any_skip_relocation, mojave:         "53ddd3c05dea30a12436e997a68ab50670bd9dbe771e3c3a6d7216c0240c6e07"
    sha256 cellar: :any_skip_relocation, high_sierra:    "8ed3df0ed73b3f995ca33b357c00f54b03f16ec2effd61eca985b04a82eb40b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fcb14a109abee4d1af24a79bc4991a851a6b1b75fd64999e815715fc54a4c834"
  end

  def install
    system "make", "-C", "src", "install", "BINDIR=#{bin}"
    doc.install Dir["docs/*"]
  end

  test do
    path = testpath/"a.asm"
    path.write <<~EOS
      !to "a.out", cbm
      * = $c000
      jmp $fce2
    EOS

    system bin/"acme", path
    code = File.open(testpath/"a.out", "rb") { |f| f.read.unpack("C*") }
    assert_equal [0x00, 0xc0, 0x4c, 0xe2, 0xfc], code
  end
end
