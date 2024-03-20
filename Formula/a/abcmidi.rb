class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2024.03.20.zip"
  sha256 "7e82f81b7c66750576063e6820e105efabd7342b182691341f9c876cb0503b89"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "63430b690a1e3495d5b9b4b5bae90704504695f6155c52beeffe5125e3569d85"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6772053e1f365194bd8d8baf565a6563ac18c75149801a9f546af76ea6c746b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "062013ac17c3109f2309f56be224a8c44af10d7232b7c56c0333b738aa1392b5"
    sha256 cellar: :any_skip_relocation, sonoma:         "2eed59a7c41b67e5df02dd62f0ffdfd2cf016de676a672229bab50faac07eafb"
    sha256 cellar: :any_skip_relocation, ventura:        "f09b6d932a8902eef9b99278554d04d696c19bf1d3754bf8771628128708e0fa"
    sha256 cellar: :any_skip_relocation, monterey:       "16d206dcc7ed56a41999b8dd942f57d267aed8c6e8349d4293eaec4e80e81af4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59b773818bfba03455cc7687f260269ae34ce0afde2f99d4d9cbf137bf0dc658"
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
