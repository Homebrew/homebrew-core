class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://www.ifdo.ca/~seymour/runabc/top.html"
  url "https://www.ifdo.ca/~seymour/runabc/abcMIDI-2018.01.02.zip"
  version "2018-01-02"
  sha256 "84700fe038e0e86432f38b237905667ecb8731960c623bf13d6c4b50d3b6e29c"

  bottle do
    cellar :any_skip_relocation
    sha256 "6715a6ec3590336d54d16dcb2d3ca320fc8b79cab82094bc3ae0b40dee61caf6" => :high_sierra
    sha256 "5961a59ba72ee2ce14f1035f8a22e11f392e014422acc28357c4e35c37de7781" => :sierra
    sha256 "d3992060684a10459396b383968ccdc478c7dcdce88904d3ad3063e3eba6c32c" => :el_capitan
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
