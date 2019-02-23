class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://www.ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2019.02.08.zip"
  sha256 "156c6a441fcec7e467f6eef943c78922f3e0dc84fb631eb949a9fa159de48b27"

  bottle do
    cellar :any_skip_relocation
    sha256 "0fe635d4894b6f2320c858b45c5a2a3ae7516ce4cf3ec9a1e5bb9fda6173c6f7" => :mojave
    sha256 "b8acba02f008c5a00c0276036e462e63a015dbaa999c7193ca2955639be3eb32" => :high_sierra
    sha256 "f8f0dec17d7bcc64c62fd9ad1b7e62c12d9d889348a6f199eb66ff29375d12fb" => :sierra
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
