class Bcpp < Formula
  desc "C(++) beautifier"
  homepage "https://invisible-island.net/bcpp/"
  url "https://invisible-mirror.net/archives/bcpp/bcpp-20150811.tgz"
  sha256 "6a18d68a09c4a0e8bf62d23d13ed7c8a62c98664a655f9d648bc466240ce97c3"

  bottle do
    cellar :any_skip_relocation
    sha256 "ca36fc5ff5890cebc995c184c9cd80d441fe5dd407d9a9ce11d662ce88df7551" => :high_sierra
    sha256 "c25d34a2e112bcdd0321d97629aa52cbfd594c1216876e759269df6ea3289e2f" => :sierra
    sha256 "7494b0aa2c2e24050eea15913c7c6a443f5bfed2640a3e53ee5fb2a3260b6495" => :el_capitan
    sha256 "d4f058c5d33b3cdffa2e844777bbd5aaa4f9b977f4cfe7ac9a31e4c0547161b0" => :yosemite
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
    etc.install "bcpp.cfg"
  end

  test do
    (testpath/"test.txt").write <<-EOS.undent
              test
                 test
          test
                test
    EOS
    system bin/"bcpp", "test.txt", "-fnc", "#{etc}/bcpp.cfg"
    assert_predicate testpath/"test.txt.orig", :exist?
    assert_predicate testpath/"test.txt", :exist?
  end
end
