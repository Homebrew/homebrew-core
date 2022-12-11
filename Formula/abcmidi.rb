class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2022.12.09.zip"
  sha256 "51264a2956817a2a198c7ba245e10b3444b2f18ad8d35e8b4b08834049cd10e0"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9ce182e6e0bb312dee0bd42158a35e5b2ccf9660439dca130265a15a4b0f3ea9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37f4a8e1841695f65343527996bc83a2a8bbb551601ac29b9fd0cdc949e0e207"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "64e1a48c57b999417d9616f5ff4ae5aeb1197947e0953b0d22e1db7408235b8e"
    sha256 cellar: :any_skip_relocation, ventura:        "96ef6d1d15c41b78abbd340dbff802037544019f8b6d794144ac73019349593e"
    sha256 cellar: :any_skip_relocation, monterey:       "db98a6c347fb64c772ec280286805665adc80728f1b5799decb4d3ebc58d8d89"
    sha256 cellar: :any_skip_relocation, big_sur:        "b57ebda6de1285eacaa410e1cf2eea7fe95d288fccb15dacf9dea58453215b9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9592cff72ed19e84ce4e21c33a85cf6df51159822f50f639382188b83151b0da"
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
