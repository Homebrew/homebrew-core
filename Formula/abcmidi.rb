class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "http://www.ifdo.ca/~seymour/runabc/top.html"
  url "http://www.ifdo.ca/~seymour/runabc/abcMIDI-2017.10.09.zip"
  version "2017-10-09"
  sha256 "21ae08fbade7b04136fc58f7f72786c5775cbc84299b4455212430b1415b4978"

  bottle do
    cellar :any_skip_relocation
    sha256 "947ae510b24a96fd0f910a35902bcaf1f93f7a718d5beceff06441280db95e19" => :high_sierra
    sha256 "150bcde4f7747385233064488a011db7a3038fe19d56719f73ec08b1076aed70" => :sierra
    sha256 "3fccd2feac7d1fb8ff5fb40d366376f648877d4e852c4bb9c9a3e731b9521f57" => :el_capitan
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
    (testpath/"balk.abc").write <<-EOF.undent
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
    EOF

    system "#{bin}/abc2midi", (testpath/"balk.abc")
  end
end
