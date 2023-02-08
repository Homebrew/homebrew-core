class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2023.02.08.zip"
  sha256 "2b8e480d7199ba098efc76940785130a5dcdfe0462a10600e9f8059be8ff2c61"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5f73d1aaad60b3cc7d5f353d545e22490b438fc49e411c92005abb2786650678"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e84e3a249a9a1b2164ba71385c77e067fceaa457da058134153c9beced69bb96"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c73f7a8edbbf5a74dae7ce606bf47b02ec6a5905bb6a67a6c8a4936ff6ae2861"
    sha256 cellar: :any_skip_relocation, ventura:        "b038132d3ddb65da80280c5558cceaa98a9f3fe708a2e2c3e90ede0059e26d76"
    sha256 cellar: :any_skip_relocation, monterey:       "796dd9dd0d6bb6351232cb95fd0b3a0282f9120799c26481e92bd2b772edf81d"
    sha256 cellar: :any_skip_relocation, big_sur:        "5350538c41a5083c9c244d76c95618ce3807b3baa36d00359ac8d6b392a9c8ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72a936f7c9d7d25bbd80e75ae01b150f41c0634c88817519d0be3ca95c447c75"
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
