class Nudoku < Formula
  desc "ncurses based sudoku game"
  homepage "https://jubalh.github.io/nudoku/"
  url "https://github.com/jubalh/nudoku/releases/download/0.2.4/nudoku-0.2.4.tar.xz"
  sha256 "4a5c6ab215ed677e31b968f3aa0c418b91b4e643e4adfade543f533ce6cde53a"

  bottle do
    cellar :any_skip_relocation
    sha256 "0bf39388df6d96c63ec97c07fc639b1be7c9c4678c2618a2208f9daf76612d57" => :el_capitan
    sha256 "287e553001990ff92d786727e9150956e0ddf00a89a6c4d32dc44e5f4851704b" => :yosemite
    sha256 "991300e012d8c3ff8709bd4b69c4d1c81a6ca09e98a6876fff8dbc517026bab0" => :mavericks
  end

  head do
    url "https://github.com/jubalh/nudoku.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "autoreconf", "-i" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /nudoku version #{version}$/, shell_output("#{bin}/nudoku -v")
  end
end
