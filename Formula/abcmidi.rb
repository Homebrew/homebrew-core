class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "http://www.ifdo.ca/~seymour/runabc/top.html"
  url "http://www.ifdo.ca/~seymour/runabc/abcMIDI-2017.11.27.zip"
  version "2017-11-27"
  sha256 "49f7b01d0332bc91eb0ad3a36f34c9b675085e6aea72ade1d9236b8b95b7b624"

  bottle do
    cellar :any_skip_relocation
    sha256 "9e362ee78b19199647d38401c6f1abc972492e8d6524577accd1d9fb5d1b7dbd" => :high_sierra
    sha256 "26ceebcafeb8d1a372d0673aa9838a15dc8ec25147a50aab85bbced29ee5d683" => :sierra
    sha256 "9a0ae40cc296c4e2f7f182fb5be12839589787bfc9af59ccb0e55e3e87d7d9fb" => :el_capitan
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
