class QalculateGtk < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-gtk/releases/download/v5.0.0/qalculate-gtk-5.0.0.tar.gz"
  sha256 "4fb840a42a2246a98db81431baf4622504a226b1d3cbbe36da5649926ad177a9"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "8c7cf3bec7930af33b396cbf478fe5109d32530274089ece16762229a320dbb1"
    sha256 arm64_ventura:  "5d6449a0cd243f126a5b0b9791d16520b578e5d914d625148db0eaf364f4f144"
    sha256 arm64_monterey: "3bcea1ac3078dc3a1b671e5f593ab2f640b3d3e1baf58a91c699d90ec9764286"
    sha256 sonoma:         "cfecd668a8e2bc26c93fb19a9f300bb6a70f212cc54975ce2a365b85e1365558"
    sha256 ventura:        "6727d07b26da124e2e9085b734b0474c4aedc69954509402796207b07b60b4e3"
    sha256 monterey:       "456eb387d1cb0231083809fa77a075d212fdabc699914fa8cd8e91190655b38b"
    sha256 x86_64_linux:   "9b81fdac2e477b64a809fb5d0d1815f1e0ab96f592b8d4f02222e777f91819aa"
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "libqalculate"

  uses_from_macos "perl" => :build

  on_linux do
    depends_on "perl-xml-parser" => :build
  end

  def install
    ENV.prepend_path "PERL5LIB", Formula["perl-xml-parser"].libexec/"lib/perl5" unless OS.mac?

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/qalculate-gtk", "-v"
  end
end
