class Ats2Postiats < Formula
  desc "Programming language with formal specification features"
  homepage "http://www.ats-lang.org/"
  url "https://downloads.sourceforge.net/project/ats2-lang/ats2-lang/ats2-postiats-0.4.2/ATS2-Postiats-0.4.2.tgz"
  sha256 "51b8e75e62321f5e3e97d7996d605c46a90c6721b568b9b52fe00c19944134d3"
  license "GPL-3.0-only"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/ATS2-Postiats[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "edc96757ad3e2248e4d87f904edeb0af670f07989406e0f5a4ae5e9e342ef959"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd07b22230211e0dd486209ccf7e4e370ae0f23cd651b57ad53ecd897143affd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9e1df17625267408944c93dc245b69d4d9fbbc94a2c61352d4ec1a23a88168e0"
    sha256 cellar: :any_skip_relocation, ventura:        "fb64d3578989ac866fbe0aa59cb22626abaa518dd0f82c196a1378b8983fd6cf"
    sha256 cellar: :any_skip_relocation, monterey:       "ea6fbabe5daedb333244e591027f092c335a08ca202863df9ea045f36d983661"
    sha256 cellar: :any_skip_relocation, big_sur:        "747125c30964abb7ad33c827104ca58fdacbba8010f19e3cbf9c0590d3b95734"
    sha256 cellar: :any_skip_relocation, catalina:       "c6906922f37376e8edc668995c8cbbf965f0da4faa63940388f26bd3d0a455af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a8f6e305de82f8adcdd01b2533de14fe9d9209d3cf9f0253ec64e5088dcc155"
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
