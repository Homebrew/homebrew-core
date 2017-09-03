class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "http://www.ifdo.ca/~seymour/runabc/top.html"
  url "http://www.ifdo.ca/~seymour/runabc/abcMIDI-2017.09.01.zip"
  version "2017-09-01"
  sha256 "67f3bc739cb9d45fefb92cfb846922ac3fa9565f48b97e70c22ffd53c0dbecb5"

  bottle do
    cellar :any_skip_relocation
    sha256 "b1d97a0bde643f3565272c15ddfe375fc173cae7c12ccc4d68f39c2aeee83365" => :sierra
    sha256 "f94a95a09103ae6db8b8b58abbed55dfbd6b2c66ca63aa3128915dacf16cf2a4" => :el_capitan
    sha256 "8c6720778cf90577c598fe35eb76a9afa05f522335c39600435bbc26d59ff7df" => :yosemite
    sha256 "adb9d06a2dea9d285dc73ccbc7146e9badb026a5900f325fdc760cacd02f7857" => :mavericks
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
