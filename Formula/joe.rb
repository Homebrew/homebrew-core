class Joe < Formula
  desc "Joe's Own Editor (JOE)"
  homepage "https://joe-editor.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/joe-editor/JOE%20sources/joe-4.4/joe-4.4.tar.gz"
  sha256 "a5704828bbca29acb9e200414fef522c66cdf9ce28150f402d6767da43460979"

  bottle do
    sha256 "80a5a41770abb8b9fd14e8ff6a3bf50a90522e11c7c8e230e54f6a1a62f2b4d4" => :sierra
    sha256 "7afafcd43650acf1797601c54f0b8f2b025364872d97d8457921b071a5735909" => :el_capitan
    sha256 "f2e8e9ac5278305083019c4a9b814f6c4432129272f8983b5e082b209428921b" => :yosemite
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "Joe's Own Editor v#{version}", shell_output("TERM=tty #{bin}/joe -help")
  end
end
