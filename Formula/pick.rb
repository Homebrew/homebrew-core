class Pick < Formula
  desc "Utility to choose one option from a set of choices"
  homepage "https://github.com/calleerlandsson/pick"
  url "https://github.com/calleerlandsson/pick/releases/download/v1.5.4/pick-1.5.4.tar.gz"
  sha256 "61de8057b1955501a8fc38227eb3ad9430bb8617480ca32c648e03c3f2c29253"

  bottle do
    cellar :any_skip_relocation
    sha256 "320de1fd40ca46c11a239b3f86e0cdd4a9fb82791670dc30f8cad59bf6d5a4c6" => :sierra
    sha256 "73c0f2f2702e6380161ebf0a7d503d549e287c8e38f84bd9676e70c18f625d91" => :el_capitan
    sha256 "fdc4572e9871a980a7a4aae10f2799fc94d0db5617ce32acebdd4636631e6770" => :yosemite
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
