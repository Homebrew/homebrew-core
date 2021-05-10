class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2021.05.09.zip"
  sha256 "f19148c27d4cc6fd818055d5f89d7bea86444ca05af5ce4d0a8f53022d5c6cc7"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "85048b383643404ed3811b0f7a5f74a08a8c7b1fb75e9a7dca1209b258c14eda"
    sha256 cellar: :any_skip_relocation, big_sur:       "e2b01edd66377f2f5a4aa33a02a7a2aee70c3abefd370639bf9cdb41983563f1"
    sha256 cellar: :any_skip_relocation, catalina:      "84e062588ccd8aa865957e8ec1895a56b56d8492ec6f3b3f7683bec0edb3511c"
    sha256 cellar: :any_skip_relocation, mojave:        "8e7cb6d765c1085475988866d91d973fa5c80eda070c4700c37877cf2244c0c1"
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
