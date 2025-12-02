class Less < Formula
  desc "Pager program similar to more"
  homepage "https://www.greenwoodsoftware.com/less/index.html"
  url "https://www.greenwoodsoftware.com/less/less-685.tar.gz"
  sha256 "2701041e767e697ee420ce0825641cedc8f20b51576abe99d92c1666d332e9dc"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/less[._-]v?(\d+(?:\.\d+)*).+?released.+?general use/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "224f9a58c2f6931c6904937fc1e6000a48d7660496500ef3778b32b406cdd639"
    sha256 cellar: :any,                 arm64_sequoia: "b3c46c6114751773d24335e6f53e542b1ff0f8abd0dc490493b32995c80d0583"
    sha256 cellar: :any,                 arm64_sonoma:  "c5a0614c46a3b03a45eeb3f2a0f7fa9e7f5baa602796aba124819a10a409d58a"
    sha256 cellar: :any,                 sonoma:        "396718e5ad00f767562be032332dc8c10b7f70b1229e1195f6f0dd8511e93116"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9517e3e0e85c024637adaa559259a84ea16a5914f249f1392343d5e79afeaa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96bba5e6136df46d4b87b865af0ba21be06a63f59a8da77550adc1fc39738590"
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
