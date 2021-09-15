class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2021.06.27.zip"
  sha256 "08ecbdda0ab81551f4d319e2db71f81f566b21adba252d8793c70a137bc0dd38"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "309575c221d6195a13aa77b95235fc6e11cad5153ebc74b8baed5e9252c92deb"
    sha256 cellar: :any_skip_relocation, big_sur:       "7240f1f7c440845ed966a4cc4f0f163af65627591411efd6753f82cd6e3f39f0"
    sha256 cellar: :any_skip_relocation, catalina:      "3d3b7913725363d966cc6d115a7601352110281f78c2efd30c396a4d3edf3516"
    sha256 cellar: :any_skip_relocation, mojave:        "d79407deb993baa511a74a8b63985ca9d5467a3d236f6b408acf38f8f05e2c4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b31103ca8b0030546ccb3a5be517a4d13009c58d363b4751bf8a70662fc1ba90"
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
