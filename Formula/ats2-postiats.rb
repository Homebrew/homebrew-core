class Ats2Postiats < Formula
  desc "Programming language with formal specification features"
  homepage "http://www.ats-lang.org/"
  url "https://downloads.sourceforge.net/project/ats2-lang/ats2-lang/ats2-postiats-0.3.7/ATS2-Postiats-0.3.7.tgz"
  sha256 "d8e78f5c6f7fd47b09da61ba6255d5054fe5bc872e5f4c3d1e420ab20393f88c"

  bottle do
    cellar :any
    sha256 "1a6111d01d2edf77a0aaaeb3272289ea3707f7a26f5d9b6aacffc896ea57d20d" => :high_sierra
    sha256 "de22f12b7bb115c9b8581fedd231e134698203ce62740b6a396eea90b410a434" => :sierra
    sha256 "6957983d0683534c2db77df0e29f2c0d0079c4ecc298a9aade88a05a033e05e5" => :el_capitan
    sha256 "42a23f6d7410ff603e52ce5fe8eed3ae015dfb4c6896c777534c65ca777fc6ce" => :yosemite
  end

  depends_on "gmp"

  def install
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}"
    system "make", "all", "install"
  end

  test do
    (testpath/"hello.dats").write <<-EOS.undent
      val _ = print ("Hello, world!\n")
      implement main0 () = ()
    EOS
    system "#{bin}/patscc", "hello.dats", "-o", "hello"
    assert_match "Hello, world!", shell_output(testpath/"hello")
  end
end
