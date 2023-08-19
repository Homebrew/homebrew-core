class Less < Formula
  desc "Pager program similar to more"
  homepage "https://www.greenwoodsoftware.com/less/index.html"
  url "https://www.greenwoodsoftware.com/less/less-643.tar.gz"
  sha256 "2911b5432c836fa084c8a2e68f6cd6312372c026a58faaa98862731c8b6052e8"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/less[._-]v?(\d+(?:\.\d+)*).+?released.+?general use/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "263b71168dfecdba1f0dce9822a5ccaaf3bf75ef89f19212b640c3df9544ddc3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "edf8e4d9c8b70364c9b6e586b115a1002b23801efcd20263217f90183005be45"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ea7446088b0a038c6c3692936f0005256f552684782fb9afa496f4488f727103"
    sha256 cellar: :any_skip_relocation, ventura:        "a3b4a5fa225f2b0f41b260e457115d4ea24cbbfa2630aadef83384d7746217fc"
    sha256 cellar: :any_skip_relocation, monterey:       "d538406b7ba642c5a3fe529af7423f13dfd44dac60bc7fe8954615cf59bbebdd"
    sha256 cellar: :any_skip_relocation, big_sur:        "fda865b847c02a8382505bcc8c1c93a8edf52ed47585006b1c2d0825cc27e788"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94de1be625ab953936a6caf6be15754dfcd6bedc4c80cd7e3855d422581e9997"
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
    system "#{bin}/lesskey", "-V"
  end
end
