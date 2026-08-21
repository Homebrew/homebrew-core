class Less < Formula
  desc "Pager program similar to more"
  homepage "https://www.greenwoodsoftware.com/less/index.html"
  url "https://www.greenwoodsoftware.com/less/less-704.tar.gz"
  sha256 "20a0b0a2bb2525fa53c7eee9beb854b4c9cf172eabb209af7020743547bfe9fb"
  license "GPL-3.0-or-later"
  compatibility_version 1

  livecheck do
    url :homepage
    regex(/less[._-]v?(\d+(?:\.\d+)*).+?released.+?general use/i)
  end

  bottle do
    sha256 arm64_tahoe:   "5a5d8c53359cd56ec9b0bfdb4da20ec5facd7dc7113da5d31f0ea2b2a330ec7b"
    sha256 arm64_sequoia: "236f1d4ef5a764122a5a47207e9b8580d3e93e493a62573025789c51a9cf4b4a"
    sha256 arm64_sonoma:  "3533b7a2c63352240072e7354828f28099aa703aa77e24671e0764b8df7e974d"
    sha256 sonoma:        "c833a353ee8cd88ccd5c893f90217c237d036c78d433fbcece2e9394952aaebc"
    sha256 arm64_linux:   "c1f2b21d1081a2e3b0bf188a02c6c5acdf4672b3d1d76f8b09c1e1c759066a9b"
    sha256 x86_64_linux:  "35714510248230c1b9b4dd7988a6f9b80aa49ce85277c16ed7913478a7de1507"
  end

  head do
    url "https://github.com/gwsw/less.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "groff" => :build
    uses_from_macos "perl" => :build
  end

  depends_on "ncurses"
  depends_on "pcre2"

  def install
    system "make", "-f", "Makefile.aut", "distfiles" if build.head?
    system "./configure", "--prefix=#{prefix}", "--with-regex=pcre2"
    system "make", "install"
  end

  test do
    system bin/"lesskey", "-V"
  end
end
