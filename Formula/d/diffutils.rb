class Diffutils < Formula
  desc "File comparison utilities"
  homepage "https://www.gnu.org/software/diffutils/"
  url "https://ftp.gnu.org/gnu/diffutils/diffutils-3.10.tar.xz"
  mirror "https://ftpmirror.gnu.org/diffutils/diffutils-3.10.tar.xz"
  sha256 "90e5e93cc724e4ebe12ede80df1634063c7a855692685919bfe60b556c9bd09e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8f7c9ed3cb94e3c5fae9f3c047999d3c49ff977cd9f23523e4b81d3abed9477f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "de3f22324953924f710369b160f3895b43423f91cc54b173abfb7f4566b1ff49"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c660290591feea403a36b8fc29e77b7844bc1e99a1fb6c7d0110f42992c4e559"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6ac63f502b1c6eec4036cae5ed7eb304fae6d64e969a5105593af0205b7a3ec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f3879ebe76278944ef87a77c3961edc55b5b3b7b51698241f3ffab2f60773812"
    sha256 cellar: :any_skip_relocation, sonoma:         "4b81b1d648a0315ae154cac38509369b58b198cf12e9f4fbd4e323193dd2f3b3"
    sha256 cellar: :any_skip_relocation, ventura:        "6cc5295c6eee5471ff65b3686b719823f989f000dfadb56f48a6b11ae11a5f83"
    sha256 cellar: :any_skip_relocation, monterey:       "e84e0576227bbe9cc7fabc085a37b3d88348d625a10f8d525cf5cea697bae4f4"
    sha256 cellar: :any_skip_relocation, big_sur:        "141bbde5bbecc9c0aed743119ec029809001396f1464db9b108fe4e30b8235d9"
    sha256                               x86_64_linux:   "2df5dd066e6fb3a926aa681e3b93414fc43244b8bc4a5da16ae161ce3966f257"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"a").write "foo"
    (testpath/"b").write "foo"
    system bin/"diff", "a", "b"
  end
end
