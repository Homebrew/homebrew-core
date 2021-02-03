class Oscats < Formula
  desc "Computerized adaptive testing system"
  homepage "https://code.google.com/archive/p/oscats/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/oscats/oscats-0.6.tar.gz"
  sha256 "2f7c88cdab6a2106085f7a3e5b1073c74f7d633728c76bd73efba5dc5657a604"
  revision 4

  bottle do
    sha256 cellar: :any, arm64_big_sur: "7b01d2f1ac68c4322d9813140ba52caac112112b74761ebb60fcf965a62045e4"
    sha256 cellar: :any, big_sur:       "778d43d3f3e60376090e898578cc8b3125a1bd6210f797954e51a8e0f362f8c5"
    sha256 cellar: :any, catalina:      "275703a9a65db9ab2a972eed4ff974f187ba2f7549305540189807c967cb45e7"
    sha256 cellar: :any, mojave:        "6e4434a738c9cce8524c2fc344c82599d11ae17621cd7cc3f506db07cbbbea5b"
    sha256 cellar: :any, high_sierra:   "41402210d7c753b1e13e2cf549bc805d219811b543b494940537e038c205fd41"
    sha256 cellar: :any, sierra:        "8ac60125dc045b55d30b3859da251f7df9004c0b8a8d32b3c10282b78becacc7"
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gsl"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
