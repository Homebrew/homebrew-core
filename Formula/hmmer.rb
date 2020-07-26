class Hmmer < Formula
  desc "Build profile HMMs and scan against sequence databases"
  homepage "http://hmmer.org/"
  url "http://eddylab.org/software/hmmer/hmmer-3.3.1.tar.gz"
  sha256 "8ce66a6930869534ad84bc7c9a5a566fd57188d6726c74c12fcd39c3c9c99bd5"

  bottle do
    cellar :any_skip_relocation
    sha256 "6cafc97dbddaa66d9e353f161ce402786d887aea8a88f52be3323ffc4cf5733b" => :catalina
    sha256 "544c93b2fc808d5176ac562689afb59785f24ef29f3198b8ca24adf2c5fab422" => :mojave
    sha256 "aac6c2a8264ae6192bff7dd02c57cfe5000e830a0991c9e5be8c0fc27b0daded" => :high_sierra
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
