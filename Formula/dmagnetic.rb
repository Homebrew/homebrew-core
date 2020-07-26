class Dmagnetic < Formula
  desc "Magnetic Scrolls Interpreter"
  homepage "https://www.dettus.net/dMagnetic/"
  url "https://www.dettus.net/dMagnetic/dMagnetic_0.25.tar.bz2"
  sha256 "5cbe2aee7e8870628eaeaf2fe3fc550f31736fe617897648a77283be6a381e6d"
  license "BSD-2-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "c586221b5c1b3eaac85f54fe4dad2a53fecf9ee2b50c7d2ab8ed55807282a3d1" => :catalina
    sha256 "dab6ec22754e7ad4ce7a6443590156ca991818556f96e8bbba9aeb08f4f50a34" => :mojave
    sha256 "50d7a04587450e65a91f455b649e750b31acc283247b28a29066bdf72d577254" => :high_sierra
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
    (share/"games/dMagnetic").install "testcode/minitest.mag", "testcode/minitest.gfx"
  end

  test do
    assert_match "ab9ec7787593e310ac4d8187db3f6cee", \
      shell_output("echo Hello | #{bin}/dMagnetic "\
        "-vmode none -vcols 300 -vrows 300 -vecho -sres 1024x768 "\
        "-mag #{share}/games/dMagnetic/minitest.mag "\
        "-gfx #{share}/games/dMagnetic/minitest.gfx "\
        "| md5").strip
  end
end
