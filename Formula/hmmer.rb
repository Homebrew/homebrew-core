class Hmmer < Formula
  desc "Build profile HMMs and scan against sequence databases"
  homepage "http://hmmer.org/"
  url "http://eddylab.org/software/hmmer/hmmer-3.3.1.tar.gz"
  sha256 "8ce66a6930869534ad84bc7c9a5a566fd57188d6726c74c12fcd39c3c9c99bd5"

  livecheck do
    url "http://eddylab.org/software/hmmer/"
    regex(/href=.*?hmmer[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
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
