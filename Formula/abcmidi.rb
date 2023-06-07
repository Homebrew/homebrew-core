class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2023.05.30.zip"
  sha256 "cc72918e44d1ca5fb9759f56cf697437873840e4401d8536b517932c6dc4a8b2"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "43450efc0c33c86231f650c2f9053cd84c28168a49058fce52b06eb8c3230246"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3c3019a8e441d5804f1a95086cf5678e2b2a513648573f7327ecc718c9e4484"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6dd9393820683d1c038deae89b23d028cbcb0c3392dcd9c7ca96d7076cb41319"
    sha256 cellar: :any_skip_relocation, ventura:        "68d26cbda5693baa65ab5b1c1ad9af56fef0aaf369154383e3f39bda76d9c870"
    sha256 cellar: :any_skip_relocation, monterey:       "87f533d93213bbebcd3f816e44048a737e24e17afdd70849bf44304ab759790e"
    sha256 cellar: :any_skip_relocation, big_sur:        "858313c053aed77aabe326c38816bed5c8641fe7f8c49dff15a417a1c0b5f8ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a21ef4ff92f7b943b82e1d49430e048f0c5b5add41ef8bdd16f7c0af063f6b78"
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
