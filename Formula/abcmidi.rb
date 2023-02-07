class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2023.02.07.zip"
  sha256 "839e6c6a5e788681d32a24abeb57f36568984073536c2cbacb7a5a8e46edd284"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f414553b08ffed9c112a74da4749cc7f154f30c05c3795f3178493a5a3e64dab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0e1864b704f901c57c77fc163aaf933f6aa5a088dd8fcff768b2a1e183fd239"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d73888afb857bde7f8140e6eff1855a5b83ea35c6d1ff1f36f070037b9713c79"
    sha256 cellar: :any_skip_relocation, ventura:        "cc3373b6087210d08d3e7ea4620e576eb4409e5ed59733013bb936c88d43201e"
    sha256 cellar: :any_skip_relocation, monterey:       "e5a2137e7e3bc5d9c28d53a70a033e848fac2d9c74e0700aca6b9d27b747844f"
    sha256 cellar: :any_skip_relocation, big_sur:        "adb257ad105d170f908c576f0b04c9a68445e4f7a5812795af0339acf3d290d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c89ddf0ff762cb3e8ed861d4489a1a76b206b7a4d54aa50546d7ddb4c6b2cb8"
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
