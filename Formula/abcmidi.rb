class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2022.01.28.zip"
  sha256 "4e8b532d3bc7af8752b0f48c810247eb18cd3e1e5b814c14a89d4e2a3bc44310"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7fe650d527b60391b251599344b803b4e9102be1111ce1b8cd8a90f5ff2659e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "89ff762640b01d40aa3b9ca0f95689834b8996d03e68f17df3695296d59af013"
    sha256 cellar: :any_skip_relocation, monterey:       "4a91ce6fb591fa5785fd5ee52b761b1b3c603a3a0ae3b1b785e4452116d84548"
    sha256 cellar: :any_skip_relocation, big_sur:        "7d9b76bf0baab536839623f9bde33e055ff0700d2c558e2ed6f875906800c658"
    sha256 cellar: :any_skip_relocation, catalina:       "a65943d6ad2ff3f375790670c6410c8f558e2a3b58acd4c0b781a32ae1479516"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eedce72ff455ae817afed5468c0476a005177fcb84975a66e9fdf804a16d5b86"
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
