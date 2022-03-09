class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2022.03.08.zip"
  sha256 "bd72bc32694eb76e4ec79ccb001a2dbcdfcd3b9c3eefef8240a6fd7323083749"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be452d3193ba1ded98c9d58231f05cd349ed9617c85a9111faeb1705243f723c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a8dd3544749dd80e79d3f32d5db5dfc1d33f05c2b234664fcc91b3c88d39cc4e"
    sha256 cellar: :any_skip_relocation, monterey:       "b878e4493be4fdb3a43ebe278b4d39f1ba8e64890b6226cc4f007ece43f17e37"
    sha256 cellar: :any_skip_relocation, big_sur:        "dc3a335fb59a55a8f5098a6ca4b4728162c587796a027e4206eb9916733d897a"
    sha256 cellar: :any_skip_relocation, catalina:       "6643da7276ea6766d4a46c327bc2c0d0351b65493c8e5a34911a8c5900f9210c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3e5d80f64d66a576b0ea26890d3815088feb5df54730080ace70a1986bfa7cb"
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
