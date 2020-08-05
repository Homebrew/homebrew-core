class Bibclean < Formula
  desc "BibTeX bibliography file pretty printer and syntax checker"
  homepage "https://www.math.utah.edu/~beebe/software/bibclean/bibclean-03.html#HDR.3"
  url "http://ftp.math.utah.edu/pub/bibclean/bibclean-3.04.tar.xz"
  mirror "https://dl.bintray.com/homebrew/mirror/bibclean-3.04.tar.xz"
  sha256 "4fa68bfd97611b0bb27b44a82df0984b300267583a313669c1217983b859b258"

  bottle do
    sha256 "15dbbabace79aafd93546976d8a899a393c6489d7951ce2bd2bb148a45f262a3" => :catalina
    sha256 "82a7919c9d5054012b54d53eacf5a9c0785105071c4c65c83bc2ff428642b3e5" => :mojave
    sha256 "9a2beadc688b6b12a22359890a6a85f20f3c79af561b5d4268e86069b806f585" => :high_sierra
  end

  def install
    ENV.deparallelize

    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}"

    # The following inline patches have been reported upstream.
    inreplace "Makefile" do |s|
      # Insert `mkdir` statements before `scp` statements because `scp` in macOS
      # requires that the full path to the target already exist.
      s.gsub! /[$][{]CP.*BIBCLEAN.*bindir.*BIBCLEAN[}]/,
              "mkdir -p ${bindir} && ${CP} ${BIBCLEAN} ${bindir}/${BIBCLEAN}"
      s.gsub! /[$][{]CP.*bibclean.*mandir.*bibclean.*manext[}]/,
              "mkdir -p ${mandir} && ${CP} bibclean.man ${mandir}/bibclean.${manext}"

      # Correct `mandir` (man file path) in the Makefile.
      s.gsub! /mandir.*prefix.*man.*man1/, "mandir = ${prefix}/share/man/man1"
    end

    system "make", "all"
    system "make", "install"
  end

  test do
    (testpath/"test.bib").write <<~EOS
      @article{small,
      author = {Test, T.},
      title = {Test},
      journal = {Test},
      year = 2014,
      note = {test},
      }
    EOS

    system "#{bin}/bibclean", "test.bib"
  end
end
