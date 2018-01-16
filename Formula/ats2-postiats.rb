class Ats2Postiats < Formula
  desc "Programming language with formal specification features"
  homepage "http://www.ats-lang.org/"
  url "https://downloads.sourceforge.net/project/ats2-lang/ats2-lang/ats2-postiats-0.3.9/ATS2-Postiats-0.3.9.tgz"
  sha256 "c69a7c58964df26227e77656659129ca4c05205d2ebcacc7084edba818fb6e81"

  bottle do
    cellar :any
    sha256 "b68cf423d03e8a3cb372df57eede48e72b26d6fce24faeb2bac84856ac25c7a5" => :high_sierra
    sha256 "8c08cc614c4d67faf13d6d9c7b7be5fb7fcca00d3721f4928c7dd9f58401d0d1" => :sierra
    sha256 "4cfd10d974ee7e0ee570adb733785a7d122262e1ea0a5dc825b51eca9409f12d" => :el_capitan
  end

  depends_on "gmp"

  def install
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}"
    system "make", "all", "install"
  end

  test do
    (testpath/"hello.dats").write <<~EOS
      val _ = print ("Hello, world!\n")
      implement main0 () = ()
    EOS
    system "#{bin}/patscc", "hello.dats", "-o", "hello"
    assert_match "Hello, world!", shell_output(testpath/"hello")
  end
end
