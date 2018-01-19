class Hmmer < Formula
  desc "Build profile HMMs and scan against sequence databases"
  homepage "http://hmmer.org/"
  url "http://eddylab.org/software/hmmer3/3.1b2/hmmer-3.1b2.tar.gz"
  sha256 "dd16edf4385c1df072c9e2f58c16ee1872d855a018a2ee6894205277017b5536"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "763753541930d4092f6e50fbde1669d9862d0ba4b096d6c6b144eb325019ca44" => :high_sierra
    sha256 "01707b89414c42564e60609e8a70f464a48bffa84278169cd3f467a885dd17a2" => :sierra
    sha256 "0f0254bebd48ec9003e6f99e2277e04914073e5dee00e764f5b5fb2ed9a7f1c3" => :el_capitan
  end

  def install
    system "./configure", "--prefix=#{prefix}"

    # Fix error: install: hmmalign: No such file or directory
    system "make"

    system "make", "install"
    doc.install "Userguide.pdf", "tutorial"
  end

  test do
    output = shell_output("#{bin}/hmmstat #{doc}/tutorial/minifam")
    assert_match "PF00069.17", output
  end
end
