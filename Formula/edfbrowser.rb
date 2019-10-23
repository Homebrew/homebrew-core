class Edfbrowser < Formula
  desc "Edfbrowser"
  homepage "https://www.teuniz.net/edfbrowser/"
  url "https://www.teuniz.net/edfbrowser/edfbrowser_170_source.tar.gz"
  version "1.70"
  sha256 "206a19e47416c278fa161c6d9bd78a3a7dd5f2c2b88deb270fb3495ffd3f659d"

  depends_on "gcc" => :build
  depends_on "qt"

  def install
    system "qmake"
    system "make"

    bin.install "edfbrowser.app/Contents/MacOS/edfbrowser"
  end

  test do
    system "#{bin}/edfbrowser", "--help"
  end
end
