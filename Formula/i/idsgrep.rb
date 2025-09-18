class Idsgrep < Formula
  desc "Grep for Extended Ideographic Description Sequences"
  homepage "https://tsukurimashou.org/idsgrep.php.en"
  url "https://tsukurimashou.org/files/idsgrep-0.6.tar.gz"
  sha256 "2c07029bab12d9ceefddf447ce4213535b68d020b093a593190c2afa8a577c7c"
  license "GPL-3.0-only"

  livecheck do
    url :homepage
    regex(/href=.*idsgrep[._-]v?(\d+(?:\.\d+)+)\.t*/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "38089cc00edfbfcda646205285bb2e4274ff12c2d3373225e16509c12bdcc304"
    sha256 cellar: :any,                 arm64_sequoia: "9195c89da2a586ec7c5d86d4b7da682d4d358ff39581755414f6040dce4db197"
    sha256 cellar: :any,                 arm64_sonoma:  "cd0cd350e0b1880c10cdb41eb85aa6a2f72829b08bffb5ef4c507ae9b75359e4"
    sha256 cellar: :any,                 arm64_ventura: "a674cfac9231215819fb5c3d6dc777f4b4ed316d2b1ef85bf959e5eb199d4414"
    sha256 cellar: :any,                 sonoma:        "f3e253e90dc6299cce14e78d01062c00aa36894449e1a2d24c93b1080613ae0f"
    sha256 cellar: :any,                 ventura:       "4a17486e3c1cd52db67298ab9ec094c171a46ae0636bc460a112b80453944645"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f532dc4ea8d251de9f344575f969d869ad14be07deffa3c86c090112232d008"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5570ed64d7e567b0ca54977415c5b45653b7e5ad1aa04ff9f2d6e30d048a536"
  end

  depends_on "cmake" => :build
  depends_on "pcre"

  def install
    system "./configure", "--disable-silent-rules"
    system "make", "idsgrep"
    bin.install "idsgrep"
    man1.install "idsgrep.1"
    pkgshare.install "chise.eids"
  end

  test do
    expected = <<~EOS
      【䲤】⿰⻥<酒>⿰氵酉
      【酒】⿰氵酉
      【鿐】⿰魚<酒>⿰氵酉
      【𤄍】⿰<酒>⿰氵酉<留>⿱<CDP-8C69>⿰<CDP-88EE>;刀田
      【𦵩】⿱艹<酒>⿰氵酉
      【𫇓】⿳⿴𦥑<林>⿰木木冖<酒>⿰氵酉
      【𬜂】⿱⿴𦥑<林>⿰木木<酒>⿰氵酉
      【𭊼】⿱<酒>⿰氵酉<吒>⿰口<乇>⿱丿七
      【𭳒】⿰<酒>⿰氵酉<或>⿹戈<CDP-8BE2>⿱口一
    EOS
    assert_equal expected, shell_output("#{bin}/idsgrep -d '...酒' #{pkgshare}/chise.eids")
  end
end
