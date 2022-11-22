class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2022.09.01.zip"
  sha256 "583933c4277760c52fffd6ec87af1b62967759378cb9f2a8b41e0da4468cac4b"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5bb8077d6cc0a549a924b076d41fc2244a4771cceb0632ea8bca7d88e492b8ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d3b9cb25733443207fad61b61b264d84b7af219db13706629d0cea3484b49e6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9c2480430d0a5a00b6c06df940bcc49d3d0e85bdcc06a8bbb4e45b4297db8ca2"
    sha256 cellar: :any_skip_relocation, ventura:        "3c8b6700316a43cf6dfaac318ac7fec1fe37b48bdadc60dcad9daa8dda1d85d2"
    sha256 cellar: :any_skip_relocation, monterey:       "8f4220120dab7f6157db034fbc4e18bce0760fc6e957604b30bb82d12ed8ea6b"
    sha256 cellar: :any_skip_relocation, big_sur:        "eb82591a23a317227699ac5b8fc27f944a4b3d61d10d97b832b99206905c959b"
    sha256 cellar: :any_skip_relocation, catalina:       "7be30959e86a787db2b8a2f15a24bb265ef1bf700c7a9e904aa992bfed7a6463"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a63df2b9e74ed271a09ef9ac6f76ba989619c805528b6254a4da77a2a004ce2e"
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
