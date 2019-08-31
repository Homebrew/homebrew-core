class Oscats < Formula
  desc "Computerized adaptive testing system"
  homepage "https://code.google.com/archive/p/oscats/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/oscats/oscats-0.6.tar.gz"
  sha256 "2f7c88cdab6a2106085f7a3e5b1073c74f7d633728c76bd73efba5dc5657a604"
  revision 4

  bottle do
    cellar :any
    sha256 "bd3ef9a463ae0804e2c6a1594bf8db92d46fb25638be69523c85333c1790e304" => :mojave
    sha256 "834912e7d371c1c054f41484eb2a171e0d39e8b44aaff909ec4d5326ff22eb7e" => :high_sierra
    sha256 "983ae6aab63fcff7e6361a053ab71d30ac30f0009aac8c99eb51400b719316d2" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gsl"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
