class Fribidi < Formula
  desc "Implementation of the Unicode BiDi algorithm"
  homepage "https://github.com/fribidi/fribidi"
  url "https://github.com/fribidi/fribidi/releases/download/v1.0.2/fribidi-1.0.2.tar.bz2"
  sha256 "bd6d1b530c4f6066f42461200ed6a31f2db8db208570ea4ccaab2b935e88832b"

  bottle do
    cellar :any
    rebuild 1
    sha256 "c0eba31658f4a732083f3af7a83f0ca59474e7197a81b76b9516c5a7b669a556" => :high_sierra
    sha256 "91f0e573d0cb0af01e46e9ebdc25b04e3d1d5ffc427aebbb51f609819391fa01" => :sierra
    sha256 "b99afe046883119dd1e1646297d67efb31e7981eb13ea4b1678718f9cce711cf" => :el_capitan
  end

  # Remove for > 1.0.2
  # Upstream commit from 19 Mar 2018 "Revert 'Add an option to disable building
  # documentation'"; see https://github.com/fribidi/fribidi/commit/095d885
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/f9c1d7d/fribidi/fix-docs.diff"
    sha256 "990777213ff47cfbf06f0342f66e84783bf5eec80419ff1582dd189352ef5f73"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-static"
    system "make", "install"
  end

  test do
    (testpath/"test.input").write <<~EOS
      a _lsimple _RteST_o th_oat
    EOS

    assert_match /a simple TSet that/, shell_output("#{bin}/fribidi --charset=CapRTL --test test.input")
  end
end
