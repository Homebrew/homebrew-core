class Latex2rtf < Formula
  desc "Translate LaTeX to RTF"
  homepage "https://latex2rtf.sourceforge.net/"
  # TODO: Switch to GitHub repo tarballs when upstream does a new release
  url "https://deb.debian.org/debian/pool/main/l/latex2rtf/latex2rtf_2.3.18a.orig.tar.gz"
  sha256 "338ba2e83360f41ded96a0ceb132db9beaaf15018b36101be2bae8bb239017d9"
  license "GPL-2.0-or-later"

  livecheck do
    skip "New git repository doesn't have 2.x tags yet"
  end

  bottle do
    sha256 arm64_tahoe:    "81a32c4137fb0b7b1f23fce3a76a90fd1c8a3196e5aafab8c9172796bd90d636"
    sha256 arm64_sequoia:  "1401d5794081fccd0385a9a5fbbb53428c2e5a6e0ea52faf745d3b08223f5ae1"
    sha256 arm64_sonoma:   "0b89a54487cfef6b584b706ed87e270fcbf3a36a840a7f349b2352e82ee0588c"
    sha256 arm64_ventura:  "b4199f9894249b485a39086d881a86500f17a61bd54c268ca8a06bba188551ca"
    sha256 arm64_monterey: "5205d467451011ecb588b38bf923bff4c50f4598ae9ede9629f7336ab4eb1dff"
    sha256 arm64_big_sur:  "29b2cd9987d2362995534aed209cf84ff93cb307de474bbe2ff16c5e94bfc9cb"
    sha256 sonoma:         "23c3852f97936ec12ff0c47a4e6711a70cd4d729f4ee6bfbecfe438d2482af8b"
    sha256 ventura:        "b4a170771dcabf60d657f8f9ac69b7bfebcc9986dcbd226d4a99909fe66bf29d"
    sha256 monterey:       "fb208afd2ae6bbb1cf5b9edfc255c46224cfdce8617220a5ce0a14686f5a503b"
    sha256 big_sur:        "fedf28c8cd7113f639a32776b9b55bbbae3ccfa7aa15e142d08004d39cf56d23"
    sha256 catalina:       "a4f536a8f9a6001fe955727e7d9473b5294daf416b422dab70b489067dad35f3"
    sha256 arm64_linux:    "8b1a51c757de5ad53a56a566565e86c7e51311927b111d16dcdf9bf15ff04e9c"
    sha256 x86_64_linux:   "4614b529d342e3e532c2c36fc3b6090dd889261c05ba3ea21847a276a063e4c5"
  end

  head do
    url "https://github.com/latex2rtf/latex2rtf.git", branch: "main"

    on_system :linux, macos: :ventura_or_newer do
      depends_on "texinfo" => :build
    end
  end

  def install
    touch "doc/latex2rtf.pdf" if build.head? # avoid texlive

    inreplace "Makefile", "cp -p doc/latex2rtf.html $(DESTDIR)$(SUPPORTDIR)",
                          "cp -p doc/web/* $(DESTDIR)$(SUPPORTDIR)"
    system "make", "DESTDIR=",
                   "BINDIR=#{bin}",
                   "MANDIR=#{man1}",
                   "INFODIR=#{info}",
                   "SUPPORTDIR=#{pkgshare}",
                   "CFGDIR=#{pkgshare}/cfg",
                   "install"
  end

  test do
    (testpath/"test.tex").write <<~'TEX'
      \documentclass{article}
      \title{LaTeX to RTF}
      \begin{document}
      \maketitle
      \end{document}
    TEX
    system bin/"latex2rtf", "test.tex"
    assert_path_exists testpath/"test.rtf"
    assert_match "LaTeX to RTF", (testpath/"test.rtf").read
  end
end
