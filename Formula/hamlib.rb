class Hamlib < Formula
  desc "Ham radio control libraries"
  homepage "http://www.hamlib.org/"
  url "https://github.com/Hamlib/Hamlib/releases/download/4.5.3/hamlib-4.5.3.tar.gz"
  sha256 "e1818e9df0e59023d2dff320c41c5c622b02a0afd3e50c3155694e1a9014f260"
  license "LGPL-2.1-or-later"
  head "https://github.com/hamlib/hamlib.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "898247044f605bd067db75f94b958d2b427b75165cc47f03f998e2e143a608e8"
    sha256 cellar: :any,                 arm64_monterey: "0a2a815e744bc96d5932f24c83c94fa9bbfbfa915ed54db9c18a4bdaac1e78f9"
    sha256 cellar: :any,                 arm64_big_sur:  "8d294c22837637322fa55aa394cd3ea43e7c483e660d9208cb60bf20f0035757"
    sha256 cellar: :any,                 ventura:        "5566547001aecd26c37f785839b0300557ac0ea2fce52d4c04b197ed49267555"
    sha256 cellar: :any,                 monterey:       "48fc9a9e12b4ec7d1dcf2028a86538cba135ff1f7e1a14c42e26fd49a14be83f"
    sha256 cellar: :any,                 big_sur:        "4b5fc6469dbeccbac18b268b4df5a09a190412ded7fb5979b9596c27ab337e38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7fdd8a3f9e716814841f841e3bf1097920b36bcd93172cefc03cd0de8565d4b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libtool"
  depends_on "libusb-compat"

  fails_with gcc: "5"

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/rigctl", "-V"
  end
end
