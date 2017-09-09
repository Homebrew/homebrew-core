class Lbdb < Formula
  desc "Little brother's database for the mutt mail reader"
  homepage "https://www.spinnaker.de/lbdb/"
  url "https://www.spinnaker.de/debian/lbdb_0.43.tar.xz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/l/lbdb/lbdb_0.43.tar.xz"
  sha256 "bbe16a21e210f237bd26a0983c54308d65cff4c4e11b44b2687c413a78ecd48a"

  bottle do
    cellar :any_skip_relocation
    sha256 "1ec7d9b55fcaf951ee1fa082aa4ff1e82d7617dd511d6bacb625584ebfdde877" => :sierra
    sha256 "8dbfea218eac1c250fc475375648ae494e56ea5ab36ea6e20751e9c56554656a" => :el_capitan
    sha256 "22fdfc4988af29d204cd7b5e32cd1d38fcea10429d79d62121fdadcd9f018f2d" => :yosemite
  end

  depends_on "abook" => :recommended

  def install
    system "./configure", "--prefix=#{prefix}", "--libdir=#{lib}/lbdb"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lbdbq -v")
  end
end
