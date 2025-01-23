class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2025.01.22.zip"
  sha256 "1f241418fba732326d918bad373b7a3d3b99e993ec075748b717041568085b6e"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5639f32dad43aa6bcae693ec0cd799475d9b32aa8106dcd3980e9bf5e0988e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d69143e73b31298cc0b6469492c0e7b443c56249862ee46c13ff32a05877487"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9513adaec7895f931664855c409b9fdb75d8b269ace58420c8fbaf44e63822bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5e8de43c4dda5846b08198cd64bb604e73a82fb5de965d07fde3b661c85b8d2"
    sha256 cellar: :any_skip_relocation, ventura:       "ef99c9b37905e4431f7ed0bf61ae4b22d07b254d047323b430c48cc598951912"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c0096e90749edfb5ecd2671d1f7d52a7672beafb82636312dcdbc11563ade04"
  end

  def install
    system "./configure", *std_configure_args
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
      %%MIDI program 23 % 23 Tango Accordion
      %%MIDI bassvol 69
      %%MIDI gchord fzfz
      |:"G"FDEC|D2C=B,|C2=B,2 |C2D2   |\
        FDEC   |D2C=B,|C2=B,2 |A,2G,2 :|
      |:=B,CDE |D2C=B,|C2=B,2 |C2D2   |\
        =B,CDE |D2C=B,|C2=B,2 |A,2G,2 :|
      |:C2=B,2 |A,2G,2| C2=B,2|A,2G,2 :|
    EOS

    system bin/"abc2midi", testpath/"balk.abc"
  end
end
