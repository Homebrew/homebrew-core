class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2022.07.31.zip"
  sha256 "b1a44a9ec42014d61c00a5ff3f39f71530a975c603b719aa16a695b7387e223b"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a98a0d18065bf8a5163490edfc97ffb02a78f02d54288fa41f38f6dd7b391d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dd96ddd7c063f6675f7b727d7c36b8b5da124c2332710bc9a55752087ad7e602"
    sha256 cellar: :any_skip_relocation, monterey:       "bb5d876e01f35f2449de34751748824906457534b33f125e2323608d0f2330dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "7d65810f1b38a7ff3512f9e88e44f5e322f9b24d885568d64803520241146ab1"
    sha256 cellar: :any_skip_relocation, catalina:       "43d8a1d6b5ee849bbd4242d142d07bff80d2718a818b8ff3f3de9ab894adfbd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "541d6fcb6e74b7423e710b9849e426e09540a7baabd346379c221afe6b4b4ce5"
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
