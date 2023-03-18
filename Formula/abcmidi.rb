class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2023.03.15.zip"
  sha256 "c82945b0088bcafd99b55f613b8dc5be3edc30a6c403b4f572472e3ba301a1f6"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74c55d78b8f77f818066879fc596e57d9b5dd6d7376af9dcee8163621782438e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "895699834c2a0cff6e1a5fb4f9dbe788cfc9006edbe145f316e91aa6cc80cf17"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "907ff59974226c6e538eab77464720a92fc06105edd7e20ce7bf8e4faea24183"
    sha256 cellar: :any_skip_relocation, ventura:        "c8deb944ff62292c833167ab8331a3bc698edb3620c7a2eeaa5420f76b68cbb5"
    sha256 cellar: :any_skip_relocation, monterey:       "03ad2527c5f05971afbe7ec961ab6850842a34c6697384adbf3faa56dc73ffd2"
    sha256 cellar: :any_skip_relocation, big_sur:        "c72087d845e2d77714781e7ab4b2f008ce91a8f8fa0c2f84973788b44e59cf04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c599131e0914d5eb88839081ab65865685a1d402edf9fa98b3b58c3ac468487"
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
