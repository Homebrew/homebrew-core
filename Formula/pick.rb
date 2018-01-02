class Pick < Formula
  desc "Utility to choose one option from a set of choices"
  homepage "https://github.com/calleerlandsson/pick"
  url "https://github.com/calleerlandsson/pick/releases/download/v2.0.1/pick-2.0.1.tar.gz"
  sha256 "4a596b8f40a316bc4e2c0d8e8842810d7a7b69d464a410e4ee2a6574e01629e3"

  bottle do
    cellar :any_skip_relocation
    sha256 "031300bf0b980a312fd1030fbcceb10c425511e8b3e904649d4ea5b055c065e5" => :high_sierra
    sha256 "26311a99440c4610cb4c80cadb73c66d0680ff8943de83eee200bd40869aaef9" => :sierra
    sha256 "9d861efcf16ede16963643921f58e4f38a8bf2903b20c51533ce98f691750977" => :el_capitan
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
