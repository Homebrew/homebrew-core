class GnuProlog < Formula
  desc "Prolog compiler with constraint solving"
  homepage "http://www.gprolog.org/"
  url "http://www.gprolog.org/gprolog-1.5.0.tar.gz"
  sha256 "670642b43c0faa27ebd68961efb17ebe707688f91b6809566ddd606139512c01"
  license any_of: ["LGPL-3.0-or-later", "GPL-2.0-or-later"]

  livecheck do
    url :homepage
    regex(/href=.*?gprolog[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "47608f61774ab4abb61279ebad504f55aec87807f65c9399f63aeec15fae16d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "311488f7874b46d9e06c9499df180ab4008260935fbe5f6335eb4cb37d303f84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ce33996a42c4d43c19084bd12fa5e6121d9b1650db96f6dd36bd1c54d85e47a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6add739b57462f42eb0dc12a1691bd83ef0075a95fa0aebe822e8c432a66aa72"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2743f08c397b6ae19c11270477b61afd7f5dc598aaaaab5146b4d5a08fd9289b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "417bfc3b0df319fa7b0b4ec3f262a5cdb3cbf8a10750c0850d9427afc3c408ac"
    sha256 cellar: :any_skip_relocation, sonoma:         "558af85d62bad07b91aeb3e7f05d8395c47e9f65d1e9aa6576a741d2ae30e992"
    sha256 cellar: :any_skip_relocation, ventura:        "02ee6b13fa27046dd98fb661dfa19671ae2ee5f724a4616a6556af48e851d08c"
    sha256 cellar: :any_skip_relocation, monterey:       "5e2d325ed9824cdf9283341f009ac01655616d8d61fe9c4b08b21f190a445611"
    sha256 cellar: :any_skip_relocation, big_sur:        "d0a8099131295fb00e49b1921a544e5cf0564593f52a35cccdae8fe239785c2c"
    sha256 cellar: :any_skip_relocation, catalina:       "7d5b67ea483e7b80e2a2d1ff30874d53afe0d5f416ef6d7e4480beaa3be6153a"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "5e968562dea6ec8f17d9d0b8f9ab48fc65179477d8e4a762371226c097c4341c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdf61462c5418578e9d629fa743b527b462e6f767fbb64af23db63115a8d39c4"
  end

  def install
    cd "src" do
      system "./configure", "--prefix=#{prefix}", "--with-doc-dir=#{doc}"
      ENV.deparallelize
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.pl").write <<~PROLOG
      :- initialization(main).
      main :- write('Hello World!'), nl, halt.
    PROLOG

    system bin/"gplc", "test.pl"
    assert_match "Hello World!", shell_output("./test")
  end
end
