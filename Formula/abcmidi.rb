class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2020.11.01.zip"
  sha256 "37140d78dbf4329f4374c4ea36d6286f5e0fb4812fccdef3782fd98c753235e7"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "2b013148c153f0dee49557daad99ecd5b70771c077739a129b23625f81fb7ee0" => :catalina
    sha256 "916f79557e947f91d39b9aeeefa1bdd034532da46d817174d197cdd07b8fbb52" => :mojave
    sha256 "184b1d4290470a4756acf100df93c50435e5b55837c9456ce587f614ac981ae3" => :high_sierra
  end

  def install
    # configure creates a "Makefile" file. A "makefile" file already exist in
    # the tarball. On case-sensitive file-systems, the "makefile" file won't
    # be overridden and will be chosen over the "Makefile" file.
    rm "makefile"

    # Fix the build issue (remove in the next release)
    inreplace "drawtune.c", "printtext(left, v->place->item, &textfont);",
                            "printtext(left, v->place->item.voidptr, &textfont);"
    inreplace "drawtune.c", "printtext(centre, v->place->item, &textfont);",
                            "printtext(centre, v->place->item.voidptr, &textfont);"

    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"balk.abc").write <<~EOS
      X: 1
      T: Abdala
      F: https://www.youtube.com/watch?v=YMf8yXaQDiQ
      L: 1/8
      M: 2/4
      K:Cm
      Q:1/4=180
      %%MIDI bassprog 32 % 32 Acoustic Bass
      %%MIDI program 23 % 23 Tango Accordian
      %%MIDI bassvol 69
      %%MIDI gchord fzfz
      |:"G"FDEC|D2C=B,|C2=B,2 |C2D2   |\
        FDEC   |D2C=B,|C2=B,2 |A,2G,2 :|
      |:=B,CDE |D2C=B,|C2=B,2 |C2D2   |\
        =B,CDE |D2C=B,|C2=B,2 |A,2G,2 :|
      |:C2=B,2 |A,2G,2| C2=B,2|A,2G,2 :|
    EOS

    system "#{bin}/abc2midi", (testpath/"balk.abc")
  end
end
