class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2022.05.05.zip"
  sha256 "ec22123b90c5ec29a54b91e4d6651c056f1ff5c168fff3256cafd3205e32ef4f"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "911ce112dcb4e6e58aa2dbe59f07b88d787cb88dc50eba7a0d7db5f671ddc7ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "07156d0c7ca62c800f39ea5eeda2f9e3af3d4e36b74a1cf73afc2c3c2c6a0455"
    sha256 cellar: :any_skip_relocation, monterey:       "78b0ef370161fd0877dbde9b89353374eeff459d7e2d9cd399a27b18c88478d8"
    sha256 cellar: :any_skip_relocation, big_sur:        "21d1ee3db44a41e383c878172c287a0df0ec467ae09d483c06b821ad6efbba34"
    sha256 cellar: :any_skip_relocation, catalina:       "9f6491602e756a6aed63e53d64bc0e8da5802203b4bb527f9f76ce1991bdafbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4a997da14f167168baf99a1d62178d54cb366d97adf750886973178764f9ad8"
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
