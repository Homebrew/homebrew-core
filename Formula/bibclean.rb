class Bibclean < Formula
  desc "BibTeX bibliography file pretty printer and syntax checker"
  homepage "https://www.math.utah.edu/~beebe/software/bibclean/bibclean-03.html#HDR.3"
  url "https://ftp.math.utah.edu/pub/bibclean/bibclean-3.06.tar.xz"
  sha256 "6574f9b8042ba8fa05eae5416b3738a35c38d129f48e733e25878ecfbaaade43"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://ftp.math.utah.edu/pub/bibclean/"
    regex(/href=.*?bibclean[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "bd8445bd033da6d614dfcc572d290be67f65cbb2fc120446c5941c84f5bd1c0d"
    sha256 arm64_monterey: "547fbf90902019ae07961d32c2a474e4d0b52901a7053ae23332e81a5d853676"
    sha256 arm64_big_sur:  "0323f9d9e011a7433a99c0fcc284b29163e3d864d55adf54063ac415fb718689"
    sha256 ventura:        "3f1ad7ffd63675963e10d88183efaa45e9756c579034350480129d509d73fe94"
    sha256 monterey:       "a40ce68874ad22f9c722f9c0f0d9189528d2f26d3da9873ade1850b18e3e467a"
    sha256 big_sur:        "7210782187577201086e8a925fd1c3a3e53987aced4a65dbe6db190cbb9dff51"
    sha256 catalina:       "27338b58717788a9e5d4edda61a255b4d7af2df8572f3dd835ebf6f68b11d3fe"
    sha256 mojave:         "6a577a2f623ac6bd1f0d17bc0cb1ac97c445b9bee0264f7284ad53a283069dc4"
    sha256 x86_64_linux:   "07ba72961d714e8146c03a61ebf78dde6d37dacdb2a2778ba747d6eaf0d61a27"
  end

  def install
    ENV.deparallelize

    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}"

    # The following inline patches have been reported upstream.
    inreplace "Makefile" do |s|
      # Insert `mkdir` statements before `scp` statements because `scp` in macOS
      # requires that the full path to the target already exist.
      s.gsub!(/[$][{]CP.*BIBCLEAN.*bindir.*BIBCLEAN[}]/,
              "mkdir -p ${bindir} && ${CP} ${BIBCLEAN} ${bindir}/${BIBCLEAN}")
      s.gsub!(/[$][{]CP.*bibclean.*mandir.*bibclean.*manext[}]/,
              "mkdir -p ${mandir} && ${CP} bibclean.man ${mandir}/bibclean.${manext}")

      # Correct `mandir` (man file path) in the Makefile.
      s.gsub!(/mandir.*prefix.*man.*man1/, "mandir = ${prefix}/share/man/man1")
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
