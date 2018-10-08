class Hmmer < Formula
  desc "Build profile HMMs and scan against sequence databases"
  homepage "http://hmmer.org/"
  url "http://eddylab.org/software/hmmer/hmmer-3.2.1.tar.gz"
  sha256 "a56129f9d786ec25265774519fc4e736bbc16e4076946dcbd7f2c16efc8e2b9c"

  bottle do
    cellar :any_skip_relocation
    sha256 "4f1756b17b1902b937df6761fe4f9d2f84af91e96655264854f204759b72bb0e" => :mojave
    sha256 "763753541930d4092f6e50fbde1669d9862d0ba4b096d6c6b144eb325019ca44" => :high_sierra
    sha256 "01707b89414c42564e60609e8a70f464a48bffa84278169cd3f467a885dd17a2" => :sierra
    sha256 "0f0254bebd48ec9003e6f99e2277e04914073e5dee00e764f5b5fb2ed9a7f1c3" => :el_capitan
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make" # Fix error: install: hmmalign: No such file or directory
    system "make", "install"
    doc.install "Userguide.pdf", "tutorial"
  end

  test do
    assert_match "PF00069.17", shell_output("#{bin}/hmmstat #{doc}/tutorial/Pkinase.hmm")
  end
end
