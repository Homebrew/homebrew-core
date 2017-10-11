class Joe < Formula
  desc "Joe's Own Editor (JOE)"
  homepage "https://joe-editor.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/joe-editor/JOE%20sources/joe-4.5/joe-4.5.tar.gz"
  sha256 "51104aa34d8650be3fa49f2204672a517688c9e6ec47e68f1ea85de88e36cadf"

  bottle do
    sha256 "c341672ca0f84ecaa08e91a7a34bb54c611354a260226114ed0a575d3e9f8058" => :high_sierra
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
