class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://www.ifdo.ca/~seymour/runabc/top.html"
  url "https://www.ifdo.ca/~seymour/runabc/abcMIDI-2018.06.13.zip"
  sha256 "daa9015791a72b66df89395c90f62c47da0caa9649ef23c05cf05ec929b345ab"

  bottle do
    cellar :any_skip_relocation
    sha256 "711809a5de09f97b89d6e600f0eb7561061cc9269175c14bce863ee1d3687a6b" => :high_sierra
    sha256 "2298eed6f8b0c1426ed6729bc0bd77de68bc2615dd07df4f5bcd3e0116d5501f" => :sierra
    sha256 "98fcfb9fc06659530f3c1ec95d779b581c74853f087a4784abd2823ddce2abce" => :el_capitan
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
