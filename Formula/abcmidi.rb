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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a616aaf5061e456a7f0c43140bb556bacd7f8eb1b857df1571ce8fb0d0f9419"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cfece4a947cd07e619b5c3cd4f71f9933b4a5c0457ca6ba99b6ac220a148b7e7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8087d861f262b6fe89f217ecc9b1f65ed9fad58d8a52aa3d24dbadf5f4a8455a"
    sha256 cellar: :any_skip_relocation, ventura:        "9fea61f019526e79d2f61bb8f880ce15cc9d08900fd4d850b52bbb4c56b2fff5"
    sha256 cellar: :any_skip_relocation, monterey:       "b59bcbf42822b033c53e7766202bcb95ea5da34a6e1d1631ba09618480a58218"
    sha256 cellar: :any_skip_relocation, big_sur:        "5e139815378592e891b0a65327dce23285d7d78c7edae56619c261c036148634"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffc988fb3cae4ac7aeeb09521955be9a418f0e67a8ae16c12c6d72071cabb06f"
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
