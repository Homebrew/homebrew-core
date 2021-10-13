class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2021.10.11.zip"
  sha256 "143780e8a45f7fa59ea73056ec22ff9494878e57889adf631cfb591e5ca426c1"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6564ff2cfa62725d46cc612e03564b4c09fcb0c7223d60fe5be65bfe3f3abc62"
    sha256 cellar: :any_skip_relocation, big_sur:       "96ba4646eb2346961131876d782570e5091bccd13a5a6e559b43a587487ee495"
    sha256 cellar: :any_skip_relocation, catalina:      "fd3b1c3d6afee4345d04e4461d38cf67f452d7872ef82550eb989db3b6293c7b"
    sha256 cellar: :any_skip_relocation, mojave:        "a38ccf13c585ec8039bb15f758a5a8e04f6042444f7742763eca536eefc63c71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e2e91c9ca55f1e4300f9830fab719b26fa676a07e6550b4794c99cf02f3df43"
  end

  def install
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
