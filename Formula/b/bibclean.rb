class Bibclean < Formula
  desc "BibTeX bibliography file pretty printer and syntax checker"
  homepage "https://www.math.utah.edu/~beebe/software/bibclean/bibclean-03.html#HDR.3"
  url "https://ftp.math.utah.edu/pub/bibclean/bibclean-3.07.tar.xz"
  sha256 "919336782e9e3c204e60f56485fd1f8dd679eb622fc8fd1f4833595ee10191a6"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://ftp.math.utah.edu/pub/bibclean/"
    regex(/href=.*?bibclean[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "879cc1d92309684de3e1d3aac3f3ceae0751b013e52bee638c67c18fd63dbf92"
    sha256 arm64_sequoia:  "13c1d6444ba0a4dd09e6840c29240a230d4d5bab8946912b275fc53fca9558bc"
    sha256 arm64_sonoma:   "9ec0d9aaf5fa2f6f48a1fd7d221a8f76d0af01d2adc36be38ad81a9660750fbe"
    sha256 arm64_ventura:  "d3fe9381c582b76b086b44099f31247d59ce061cd28332df637410c9249ea801"
    sha256 arm64_monterey: "13dab8081ee1d770d8ee59434aff9960da2210f8e20c41f95d23cdfa263b2041"
    sha256 arm64_big_sur:  "70485db89737d51bba727bac3ba1a8d736b7f9f128c5a3ec9edaeebfc35c6531"
    sha256 sonoma:         "4f6f06f2b94c6d0d8f113b494cefd204f2ae7f1d12e67ba5752dd5cb4b9da50f"
    sha256 ventura:        "b186cd7d543fd826e467a97c399e9fbd0cffb1bf65db3e31967aac99ef685093"
    sha256 monterey:       "0fd480cd271181b46c149447a7e982d70e7f196548407ed20a7557066e5124eb"
    sha256 big_sur:        "dd7f3ef2672e9f562a7248ae269a12b959b6606dff0aac1fbc0b59869a7d1fd3"
    sha256 arm64_linux:    "d700d842f1381f0c09f7580584db46a2ccc558fd0fbf95b17fc45ea242061036"
    sha256 x86_64_linux:   "3e6f4a7531a9e96f3cdb75f01271287c7bb477566ccf80438895c730d35c995d"
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
    (testpath/"test.bib").write <<~BIBTEX
      @article{small,
      author = {Test, T.},
      title = {Test},
      journal = {Test},
      year = 2014,
      note = {test},
      }
    BIBTEX

    system bin/"bibclean", "test.bib"
  end
end
