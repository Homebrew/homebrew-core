class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2022.01.27.zip"
  sha256 "b47bae883f7dde9c6cdcf74dd92560e8b0bb527150e49d06e6b016735ad6761c"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53a302dfa170f12ef1714e1b0356dbb48d94946218155698e216923787e99fd3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2eee57a84f4389019fdfa38a181037442cdf0087fe1bbbde1527327d03e3040b"
    sha256 cellar: :any_skip_relocation, monterey:       "c2b743cbcd958766e261c33951d7882491bce79bf809d6690bb8732bb685efe8"
    sha256 cellar: :any_skip_relocation, big_sur:        "30e20c03b2d4cc8058bb7934778ab098865a1da7fc719a84b525df0ca2e28394"
    sha256 cellar: :any_skip_relocation, catalina:       "06a07aa2809e7a3b051ad3c82f9c85f4d31b2a4d916aeb80a2112b799cc267e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18af41557665c34bd2c67784412ec7ff14ae126258c955464df3dd967d2b4cef"
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
