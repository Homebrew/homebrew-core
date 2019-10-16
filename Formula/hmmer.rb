class Hmmer < Formula
  desc "Build profile HMMs and scan against sequence databases"
  homepage "http://hmmer.org/"
  url "http://eddylab.org/software/hmmer/hmmer-3.2.1.tar.gz"
  sha256 "a56129f9d786ec25265774519fc4e736bbc16e4076946dcbd7f2c16efc8e2b9c"

  bottle do
    cellar :any_skip_relocation
    sha256 "b7d65153f779a1de7196a6434617eb870a9aa7a8edfd8abc58bc36fecd61da2d" => :catalina
    sha256 "f31890fbde868fc82a2820f17174eb905144f4dea67d5d91a88363645279341b" => :mojave
    sha256 "c2343ad2d3c2fc7a1b02bda605096cb3efc895be458eb219a0e8eee3cc805474" => :high_sierra
    sha256 "81c3660f5c0c9a7ef21dbca50e6f871bf1ea48af8e59de293e988e682dc16e6e" => :sierra
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
