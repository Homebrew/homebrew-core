class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2024.03.13.zip"
  sha256 "939a578551a53147b761e3199a786219153507117be4bb1296cde210b4e25e96"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "411acc9976db90afabe7a484bc66a4f360d1c84d16296e481169901aa4245197"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d115e6bce428010accdf0e731731612fd673a60c45a94278024b1bcbf46c9e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d13110b9b56910e190898ba8604b11b8686eda9f5c1fb6d1fc09666693041e07"
    sha256 cellar: :any_skip_relocation, sonoma:         "535949b98c5bef4ea1a6719454559f7a9abbced403c4b18f2af9cf5bb83ca3c3"
    sha256 cellar: :any_skip_relocation, ventura:        "4f25ac23956469a9adda117d65ecc07c1bce955214f41a6920ba9b7476b8f9e4"
    sha256 cellar: :any_skip_relocation, monterey:       "89f3eef6b073c234db501b496133ff5db15cdfb7cbaed59a811da5253878aac3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b661c2dad8f3596267a25c6646052c0f0b3d2f02e7977ee64249f5025b39ad6f"
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
