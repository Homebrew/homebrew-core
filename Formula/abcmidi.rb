class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://www.ifdo.ca/~seymour/runabc/top.html"
  url "https://www.ifdo.ca/~seymour/runabc/abcMIDI-2018.06.23.zip"
  sha256 "3018b467c17dabee92d728c2a344100928efc8791922f3d889099722db68c1f0"

  bottle do
    cellar :any_skip_relocation
    sha256 "ccc56b114ce9db4371c000dff8eb5c0db13d7de0f9a3518a4416c34dd5f17c8a" => :mojave
    sha256 "b3559c7dff532dafb8072a9edaea4ea84f6e9fec7f33e4ffdd61a400cb47ada9" => :high_sierra
    sha256 "1af2dda55544c81d912410262bf2d6795da221fa1877df125cd8f7cca33ce971" => :sierra
    sha256 "bd75e233967a9c45173f539768596ece1ba1ed6e3976a52da61dd4ecd733c3d5" => :el_capitan
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
