class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2024.02.14.zip"
  sha256 "63177baeb267da3b418787350794374d1ed8a25648605207ffb3548ba22f68d7"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c9fdae2f37f93df491a9c4a46e341c006500afc86e5740d8602973dfb98f6a38"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "886ccf5b554c469d7c3b5839490430bff079ec1223736b462316facf5ae5a617"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30172b07667c59f6caf20f363be26f8b6c20fe1974e997cd8419dffa16964677"
    sha256 cellar: :any_skip_relocation, sonoma:         "d411402a0a0dde482b96563241c70d6b04fe4276fb286f170f95c94ddacd1b7a"
    sha256 cellar: :any_skip_relocation, ventura:        "0678e28c59642b00db636c066a5d613e05c0b9a56db63affe141d7d532c92533"
    sha256 cellar: :any_skip_relocation, monterey:       "7fe587fae4dee4790e5941927019166745429b5985992721473d8a70c002931d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d8b240c8193e31ad9fa64ab2ecd2810e6299f71784a4f6a58f9fc24053dd24c"
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
      %%MIDI program 23 % 23 Tango Accordion
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
