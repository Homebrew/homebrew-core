class Oscats < Formula
  desc "Computerized adaptive testing system"
  homepage "https://code.google.com/archive/p/oscats/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/oscats/oscats-0.6.tar.gz"
  sha256 "2f7c88cdab6a2106085f7a3e5b1073c74f7d633728c76bd73efba5dc5657a604"
  revision 4

  bottle do
    cellar :any
    sha256 "275703a9a65db9ab2a972eed4ff974f187ba2f7549305540189807c967cb45e7" => :catalina
    sha256 "6e4434a738c9cce8524c2fc344c82599d11ae17621cd7cc3f506db07cbbbea5b" => :mojave
    sha256 "41402210d7c753b1e13e2cf549bc805d219811b543b494940537e038c205fd41" => :high_sierra
    sha256 "8ac60125dc045b55d30b3859da251f7df9004c0b8a8d32b3c10282b78becacc7" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gsl"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
