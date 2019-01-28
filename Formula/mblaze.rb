class Mblaze < Formula
  desc "Maildir-focused command-line mail client"
  homepage "https://github.com/chneukirchen/mblaze"
  url "https://github.com/chneukirchen/mblaze/archive/v0.4.tar.gz"
  sha256 "83dffd7fe74fa871642e97db94e27c04506f746fa4d6ba2f95c1a880638d6e0c"

  def install
    system "make"
    system "make", "check"
    system "make", "install", "PREFIX=#{prefix}"

    bin.install "contrib/mencrypt"
    bin.install "contrib/menter"
    bin.install "contrib/mgpg"
    bin.install "contrib/mp7m"
    bin.install "contrib/mraw"
    bin.install "contrib/mrecode"
    bin.install "contrib/msign"
    bin.install "contrib/mverify"
    bin.install "contrib/mvi"
  end

  test do
    maildir = testpath/"maildir"
    system "#{bin}/mmkdir", maildir
    assert_equal maildir.to_s, shell_output("#{bin}/mdirs #{testpath}").strip
  end
end
