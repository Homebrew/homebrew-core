class Feh < Formula
  desc "X11 image viewer"
  homepage "https://feh.finalrewind.org/"
  url "https://feh.finalrewind.org/feh-3.4.1.tar.bz2"
  sha256 "782463034ab0135bc8438515191f986db23a79d502154d23a7c07a7574907b7b"
  license "MIT-feh"

  bottle do
    sha256 "98b2f6ddf9c5c6a8125b21c61b26d0d3700ca162a93ec066a1561f5527a6a8e9" => :catalina
    sha256 "90542761b029fe82938b6394800471fc66b07feb6efc541662e734a8e607d66c" => :mojave
    sha256 "531714d85099fa6387282950462b646877d9e15ddae0f7e76864d27df0c81373" => :high_sierra
  end

  depends_on "imlib2"
  depends_on "libexif"
  depends_on :x11

  def install
    system "make", "PREFIX=#{prefix}", "verscmp=0", "exif=1"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/feh -v")
  end
end
