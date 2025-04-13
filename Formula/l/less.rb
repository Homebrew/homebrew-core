class Less < Formula
  desc "Pager program similar to more"
  homepage "https://www.greenwoodsoftware.com/less/index.html"
  url "https://www.greenwoodsoftware.com/less/less-668.tar.gz"
  sha256 "2819f55564d86d542abbecafd82ff61e819a3eec967faa36cd3e68f1596a44b8"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/less[._-]v?(\d+(?:\.\d+)*).+?released.+?general use/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d697a1fe935515da404479a4886cf9f44f377cf09d93b5b85596774030efc2b3"
    sha256 cellar: :any,                 arm64_sonoma:  "a187e2013023daa1910e3ba51e317c7958b14eff51ae7f0ac50b0c239062a70f"
    sha256 cellar: :any,                 arm64_ventura: "58a76058176707e39b5065c4a105b2f7f45c868845a411d81b15ce613cbb3ecb"
    sha256 cellar: :any,                 sonoma:        "1194fae6d84f21aa62a7872af689067e67acc4f3c95baa5a75c04cf2a1946931"
    sha256 cellar: :any,                 ventura:       "704d6a4b11de0f6e2662a7363c1793499bd4855b16e5ff63039b7bdba24ac902"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a45ea206d3258be6b1d99b09aecdc72d19a5ecac6e462207feea6e3ce364d24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e86542d7e69cbe139d7cb84746d0567fc997ace251a2e443600c5957af7eb9c"
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
