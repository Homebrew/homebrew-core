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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7bbb33ed38f9cf794eb378b203f879a52c77b2a84f279a7c14d82855a6112530"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3640f67292e2f5d385f5a086589ba4bdca5fc3f4863497c6f1b6eed531d2da85"
    sha256 cellar: :any_skip_relocation, monterey:       "88b7713c0a1500e3e970b67b94b1958f385d25808fe1287a6c459e6531b3e584"
    sha256 cellar: :any_skip_relocation, big_sur:        "7177f9004bfe49958b146405c4d3697c28aeeed0210976f58cc93147a2a57d93"
    sha256 cellar: :any_skip_relocation, catalina:       "1c065617a5671efc819c0906224e8b785836686945660f62ca2c8a2b78f14bc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52987f371cc651884834f6f9c5bcabc48a8dc1e63e0d1d12bbf5b1cd7a564dc0"
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
