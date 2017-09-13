class Pick < Formula
  desc "Utility to choose one option from a set of choices"
  homepage "https://github.com/calleerlandsson/pick"
  url "https://github.com/calleerlandsson/pick/releases/download/v1.8.0/pick-1.8.0.tar.gz"
  sha256 "7834d3aef9e575ce07414f961d1f024776b49bb23c5dc3b7bb8f6b734131067d"

  bottle do
    cellar :any_skip_relocation
    sha256 "294113d7ae651a7ca9b9641c1db5ba6784fa2e6926bf433d3fb2dca87ea12d41" => :sierra
    sha256 "2245f9cc18f0d369c014a9b5f841359495b75bdeda1ea767506af4f01a1b2618" => :el_capitan
    sha256 "7c381625b1aabd2e07a0662428026c9f011a3a57e815cf7c6f0a4b38e46552c4" => :yosemite
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/pick", "-v"
  end
end
