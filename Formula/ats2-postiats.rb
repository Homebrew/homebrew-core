class Ats2Postiats < Formula
  desc "ATS programming language implementation"
  homepage "http://www.ats-lang.org/"
  url "https://downloads.sourceforge.net/project/ats2-lang/ats2-lang/ats2-postiats-0.2.6/ATS2-Postiats-0.2.6.tgz"
  sha256 "3179a33eb059992bbab0a172fc0daecc562d9d255797bfda4cabe69e2be2ca41"

  bottle do
    cellar :any
    rebuild 1
    sha256 "3ff22717f6e9d15919d051744ae0cd13fa063065eee796d50d14ba756a78e500" => :sierra
    sha256 "06f7d6df07dc22d913d19eabd9b4c2116bbd2585411beb708fc3f5f8ff4e3e29" => :el_capitan
    sha256 "d587bd78cd11b167bc7ed1f1b860521d12203a15135154932ce1b3c1fb020736" => :yosemite
    sha256 "90674afecca582da2ff2c7ab2caf0e5c8ed766eadd395b4a1a0ef800e2eed31a" => :mavericks
  end

  depends_on "gmp"

  # error: expected declaration specifiers or '...' before '__builtin_object_size'
  # Already fixed upstream. Can remove this on next release.
  patch do
    url "https://github.com/githwxi/ATS-Postiats/commit/5b3d6a8ac7.diff"
    sha256 "9e7ceea54d9e02323711e0ede3b64528f008f084007a0bea43ce2be9b31d916a"
  end

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
