class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2022.04.28.zip"
  sha256 "f6acfeda456733b3497f18eada27f3a7ec9127350fe759031695e362e308799e"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05dce5b5c3f5ed2e366948f9e8ecfc9e1db680e8fedd81b65daaf11d9c07fd62"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da532836dbdee0b63117747bfa9ace4e02284143804855c44f0f56d69b88e9e8"
    sha256 cellar: :any_skip_relocation, monterey:       "a2e906df4e90726be4f74ce46efe54a52a1b9c4ecda89f33b7ec3b318f526958"
    sha256 cellar: :any_skip_relocation, big_sur:        "14b0437a2f42332e479dfa3958f7ec6e3c06c2c994740996efeed682445790a5"
    sha256 cellar: :any_skip_relocation, catalina:       "1a825cf5f474c38d864770bd33d90f94c0877ca14e4b4b9b479fbffe588689ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c39bf54306ea1474774a9d1904513396f375ff6bae71b4b187d575763eba1cb"
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
