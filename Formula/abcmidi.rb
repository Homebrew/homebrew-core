class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2021.01.25.zip"
  sha256 "5f3c676d3aa2645172b649b2fece6ee36de733c6dd14c717b0720b6fbaca70c3"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "991e24fef1645e9357b4dfb3a2fcbcec6afb978f40d08646a755fb5dc8a73846"
    sha256 cellar: :any_skip_relocation, big_sur:       "e356ba35a777c2b28e9b745a644a0c1ae1eac513d3c37a3c3e838f96010422b8"
    sha256 cellar: :any_skip_relocation, catalina:      "6552cbc1dde9ee3459af4c80608fa0f4b2c3a087130592c8dd1d4c5e84ab2796"
    sha256 cellar: :any_skip_relocation, mojave:        "fc00db07ef366740523d83f89e87b1dd8da2841bf7b9ce7dac55337c3885c466"
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
