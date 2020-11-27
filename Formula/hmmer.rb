class Hmmer < Formula
  desc "Build profile HMMs and scan against sequence databases"
  homepage "http://hmmer.org/"
  url "http://eddylab.org/software/hmmer/hmmer-3.3.2.tar.gz"
  sha256 "92fee9b5efe37a5276352d3502775e7c46e9f7a0ee45a331eacb2a0cac713c69"
  license "BSD-3-Clause"

  livecheck do
    url "http://eddylab.org/software/hmmer/"
    regex(/href=.*?hmmer[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "ea9e311fa473eae73ed2b023faaa9df5f9c190d36ab9190cf3def3cb6861a0fb" => :big_sur
    sha256 "438b4330b30b95486261d55bf3073bd2032842f3cd4acf64d295324440db7b6b" => :catalina
    sha256 "cf633a2db613b4c5e95632d125a737fe978bec225ec3df48fb4c356dc41ed385" => :mojave
    sha256 "c86672e08a73cd19f2cf3f3f02f9907d85c9ab9a7a716aa1861845f001902497" => :high_sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
    doc.install "Userguide.pdf", "tutorial"
  end

  test do
    assert_match "PF00069.17", shell_output("#{bin}/hmmstat #{doc}/tutorial/Pkinase.hmm")
  end
end
