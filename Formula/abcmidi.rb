class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "http://www.ifdo.ca/~seymour/runabc/top.html"
  url "http://www.ifdo.ca/~seymour/runabc/abcMIDI-2017.11.08.zip"
  version "2017-11-08"
  sha256 "b66904f5c14ad43da32a8e0956e0dadc2e4f4ff49cc0bb6337703de773661aaa"

  bottle do
    cellar :any_skip_relocation
    sha256 "a3542cc7cf884f706e419a15c18b28636e74e84aec99bbdd23fe2cb64d8a87f6" => :high_sierra
    sha256 "f35915c99c7f3adb85c16c40af3ead70d049b8ad1ae24f496e88f7dcd387d60d" => :sierra
    sha256 "58c16f29e9f7974bd67b0f6300b11872767ec18bc140f773d2430e5b5346cb09" => :el_capitan
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
