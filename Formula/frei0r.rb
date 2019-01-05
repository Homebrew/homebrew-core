class Frei0r < Formula
  desc "Minimalistic plugin API for video effects"
  homepage "https://frei0r.dyne.org/"
  url "https://files.dyne.org/frei0r/releases/frei0r-plugins-1.6.1.tar.gz"
  sha256 "e0c24630961195d9bd65aa8d43732469e8248e8918faa942cfb881769d11515e"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a509ee11dc4a3cd431a888c708d32c53d81e5ca67250520f91284d4370d946d4" => :mojave
    sha256 "7bef9c45d808de6bf3f7026ff0c96e4ddadd2ca3a5f8737ce9041f7aa828e6a1" => :high_sierra
    sha256 "28d07c64bce38e3fa9c76437ce86b86ae34ac317070f1e167dbbc1f825f68b46" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "pkg-config" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
