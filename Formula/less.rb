class Less < Formula
  desc "Pager program similar to more"
  homepage "https://www.greenwoodsoftware.com/less/index.html"
  url "https://www.greenwoodsoftware.com/less/less-581.2.tar.gz"
  sha256 "ce34b47caf20a99740672bf560fc48d5d663c5e78e67bc254e616b9537d5d83b"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/less[._-]v?(\d+(?:\.\d+)*).+?released.+?general use/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "9e0c12d3d5fb90f1b8c6019640952850d46a67b4fbe6a97fd588c8a33e8257f7"
    sha256 cellar: :any, big_sur:       "25c7f4a05a8c1796a2e5852af187d6fed214a4eebdf208cddf10943d9304128c"
    sha256 cellar: :any, catalina:      "ec99b4636cf2cf7be091512342b4d4814d1c7aaf77dc06847b0faf93c614a3e2"
    sha256 cellar: :any, mojave:        "c9beae597064d6622349a334f164b02522f25535ccb3969349d18d60c1252032"
  end

  head do
    url "https://github.com/gwsw/less.git"
    depends_on "autoconf" => :build
    uses_from_macos "perl" => :build
  end

  depends_on "ncurses"
  depends_on "pcre"

  def install
    system "make", "-f", "Makefile.aut", "dist" if build.head?
    system "./configure", "--prefix=#{prefix}", "--with-regex=pcre"
    system "make", "install"
  end

  test do
    system "#{bin}/lesskey", "-V"
  end
end
