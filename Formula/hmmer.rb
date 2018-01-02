class Hmmer < Formula
  desc "Build profile HMMs and scan against sequence databases"
  homepage "http://hmmer.janelia.org"
  url "http://eddylab.org/software/hmmer3/3.1b2/hmmer-3.1b2.tar.gz"
  sha256 "dd16edf4385c1df072c9e2f58c16ee1872d855a018a2ee6894205277017b5536"

  head do
    url "https://svn.janelia.org/eddylab/eddys/src/hmmer/trunk"
    depends_on "autoconf" => :build
  end

  def install
    system "autoconf" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "PF00069.17", shell_output("#{bin}/hmmstat #{doc}/tutorial/minifam")
  end
end
