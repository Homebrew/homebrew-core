class Ats2Postiats < Formula
  desc "Programming language with formal specification features"
  homepage "http://www.ats-lang.org/"
  url "https://downloads.sourceforge.net/project/ats2-lang/ats2-lang/ats2-postiats-0.3.12/ATS2-Postiats-0.3.12.tgz"
  sha256 "63eb02b225a11752745e8f08691140ed764288ab4ceda3710670cde24835b0d8"

  bottle do
    cellar :any
    sha256 "b451498a16a5e4af15a0f08101926ccfa6e78e6e3d34573897891bba906d42d3" => :mojave
    sha256 "b149d55a64bf358dc26cba82dd393ca8d680c1f1a55d3b1e8153b0a9aa5e0c30" => :high_sierra
    sha256 "2611492fad5a912fceddcb691cfb5b4843436b9abf6af54747e1e324ed20e026" => :sierra
    sha256 "f517b798a720d0782a6c2bc319a439aac5c92e7dee3e0baf57c49a1bd4aeee5f" => :el_capitan
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
