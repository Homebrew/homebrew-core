class Hmmer < Formula
  desc "Build profile HMMs and scan against sequence databases"
  homepage "http://hmmer.org/"
  url "http://eddylab.org/software/hmmer3/3.1b2/hmmer-3.1b2.tar.gz"
  sha256 "dd16edf4385c1df072c9e2f58c16ee1872d855a018a2ee6894205277017b5536"
  revision 2

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
