class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2024.03.21.zip"
  sha256 "bd75dfc050697755a69f983005770deb3ae114249c0f8de94583ae89581e613d"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "42058e83960e60821e8bb0305fa48b07b4cf77f65ad29748507b935a9ac1d9d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab61c542fbd1c75bef34424aded2c4335bd5f22b13bbbc590175a8c390001e07"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4b75cbf1b42ed702ab6193d09b011b28cf5acc8e12cf0c8e58667cfb8ef6283"
    sha256 cellar: :any_skip_relocation, sonoma:         "d216ed90ad8fddf1a44cde14f2fead343b66666c70ec339892ca3eaab77e01d6"
    sha256 cellar: :any_skip_relocation, ventura:        "14445a3dca5e8d5877f56f935d62e3a781fbbe3b15a223405ac0438a2a450855"
    sha256 cellar: :any_skip_relocation, monterey:       "bd4f03e7c320a57791bcb12524447b9914ff08763c238fb08a3bb51e2b05b095"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58764c2c899364e8240401ce330a8a6c180994b04cefb6e95e7fd51334ce78e0"
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
