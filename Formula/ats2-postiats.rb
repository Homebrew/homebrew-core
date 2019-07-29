class Ats2Postiats < Formula
  desc "Programming language with formal specification features"
  homepage "http://www.ats-lang.org/"
  url "https://downloads.sourceforge.net/project/ats2-lang/ats2-lang/ats2-postiats-0.3.13/ATS2-Postiats-0.3.13.tgz"
  sha256 "0056ff5bfa55c9b9831dce004e7b1b9e7a98d56a9d8ae49d827f9fd0ef823c23"

  bottle do
    cellar :any
    sha256 "751f4582b45bf5b5f3e319f7cd40d3c02ccdca5024e5700062cb14faf3106888" => :mojave
    sha256 "1c0c128bf522b6780e1ff36b2ad959e9ccad36198411dbd5d21395baa412bfde" => :high_sierra
    sha256 "ee94f5c6675016834a7d864d6aa78515589f26a10ad3a650983259f3732e1630" => :sierra
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
