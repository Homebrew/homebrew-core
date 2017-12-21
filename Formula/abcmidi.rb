class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "http://www.ifdo.ca/~seymour/runabc/top.html"
  url "http://www.ifdo.ca/~seymour/runabc/abcMIDI-2017.12.20.zip"
  version "2017-12-20"
  sha256 "9b48e060a77750598fbb3aaa4cf09f7366b7a498a57b7cb93f6ac31286b58596"

  bottle do
    cellar :any_skip_relocation
    sha256 "03b3393561d98018a1d8283bc8a7a088df8b2b8a037fd54d6cede3ed47622866" => :high_sierra
    sha256 "6b980ae8884c9121492296a7538ae8646bc7ba4f402065325f4ba93379ba2f96" => :sierra
    sha256 "7d3e21cbb450be0e1b354e7af1ea21e90c59add35f4259b88fe6b0afc6a5bcee" => :el_capitan
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
