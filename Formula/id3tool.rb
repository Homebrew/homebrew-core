class Id3tool < Formula
  desc "ID3 editing tool"
  homepage "http://nekohako.xware.cx/id3tool/"
  url "http://nekohako.xware.cx/id3tool/id3tool-1.2a.tar.gz"
  sha256 "7908d66c5aabe2a53ae8019e8234f4231485d80be4b2fe72c9d04013cff1caec"

  bottle do
    cellar :any_skip_relocation
    sha256 "053ce5a2222cac2bdecff1e97e73110af9cfbb199b77441ec5db19b4fc7ef1ae" => :mojave
    sha256 "c98d949a63b2d26f6cff9d63d24ecdfbd48196f58111a9a244ec7319d2ea7c21" => :high_sierra
    sha256 "2b7bcf184092881638221c606ae50879d02478bf9d433dc946f63dbe2e68368a" => :sierra
    sha256 "b5b4d49b4710a67df5200149873dd8c17131ef4a4eaac722a2095b1445d053ff" => :el_capitan
    sha256 "348a229d26dd699013d8e3372c5382da10b12d02d286304e61d9f2c71ed77101" => :yosemite
    sha256 "dd989abacf0c1113879b6864a5ca08a59ac766a320897b9c323e5f7eaeeb2e70" => :mavericks
    sha256 "49ff675bc30c8e195f50c7dcc8f4a52a06ade28e6e84950be3d15048eeacfdd4" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    mp3 = "#{testpath}/test.mp3"
    cp test_fixtures("test.mp3"), mp3

    system "#{bin}/id3tool", "-t", "Homebrew", mp3
    assert_match(/Song Title:\s+Homebrew/,
                 shell_output("#{bin}/id3tool #{mp3}").chomp)
  end
end
