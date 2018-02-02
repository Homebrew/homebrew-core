class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://www.ifdo.ca/~seymour/runabc/top.html"
  url "https://www.ifdo.ca/~seymour/runabc/abcMIDI-2018.01.24.zip"
  version "2018-01-24"
  sha256 "056c1a2ffb0451c671c5db303db20463e31e2de5d92860b8100c4207fc2f0737"

  bottle do
    cellar :any_skip_relocation
    sha256 "b18aa71b750bf34ca9013fc81c7eaf6aff5afafc07736a56c2b87cb6144e9455" => :high_sierra
    sha256 "6db9e7e5f174995a753a8a63a6a82274e58c78974db7a54d29a4f6e23e6012f2" => :sierra
    sha256 "2093c76f4128967cffcf7c1d8ebc290de03dded74865b1bb7da8d6d697e19a5d" => :el_capitan
  end

  def install
    # configure creates a "Makefile" file. A "makefile" file already exist in
    # the tarball. On case-sensitive file-systems, the "makefile" file won't
    # be overridden and will be chosen over the "Makefile" file.
    rm "makefile"

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
