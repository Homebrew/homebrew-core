class Posh < Formula
  desc "Policy-compliant ordinary shell"
  homepage "https://salsa.debian.org/clint/posh"
  url "https://salsa.debian.org/clint/posh/repository/debian/0.13.2/archive.tar.gz"
  sha256 "d4ea1e08b4e2916a6a43f50f7892ab4152e9438b19f7a008e5b2a46e4f5ac774"

  bottle do
    cellar :any_skip_relocation
    sha256 "9ae1e9c7c227d5c7ce6e5aede848668c1268ffddd66029a57ae6352fd75d179b" => :mojave
    sha256 "548e5330c43d793d53a5367a20c8538659c2b01ec89e1e38adb77af84220f56d" => :high_sierra
    sha256 "b3c765a3f11f264415f1438db4c20e77c4202e8a894d67be5ab60ce2bbfb30a1" => :sierra
    sha256 "d8018f086dea30a4225641c56255dff05a45d5eea16707822c1e13364b44ecbc" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/posh -c 'echo homebrew'")
    assert_equal "homebrew", output.chomp
  end
end
