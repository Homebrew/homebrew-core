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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f5d9c2e4f37ef2021188a905b93ce99547ac1047597d67baa2e16d83b214492"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6ead56bc7aeaddcbfed8f909aea2920fe1d219a7060d99666d072afaf7ad1cb7"
    sha256 cellar: :any_skip_relocation, monterey:       "677bb7e8026215bd1043ba641d6fdd293acb513e230697c45edcd7cb09a53092"
    sha256 cellar: :any_skip_relocation, big_sur:        "81819624feb1ae3ffba48e1fc35095adf0aaa3040fbda6e49f3252542e054fe9"
    sha256 cellar: :any_skip_relocation, catalina:       "164b8ca887238168f598fc9e6c2041950afcc40354081adc41bac5356d572926"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e02246996d5966794073ae673399b8d782bc6bf8abe7b795435db6c2ffe298f5"
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
