class Jdupes < Formula
  desc "Duplicate file finder and an enhanced fork of 'fdupes'"
  homepage "https://github.com/jbruchon/jdupes"
  url "https://github.com/jbruchon/jdupes/archive/v1.13.1.tar.gz"
  sha256 "6b68ea30b0d8fceb31ccbc07187133dbff0cc84678752e89ad3270c89322710f"

  bottle do
    cellar :any_skip_relocation
    sha256 "28b820fd824d49bf2278f81dc0c37a9d2aa8d0ae0202a7a71c00443d9320cc52" => :mojave
    sha256 "5d14b46bea9793156be62d73cf46356dfe09f082c0ff0f05ca455f4e6e3b1770" => :high_sierra
    sha256 "8a42c6af41d1c95cc5dac071837ca56891849733efece76464a8a6b2ce31b9ec" => :sierra
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    touch "a"
    touch "b"
    (testpath/"c").write("unique file")
    dupes = shell_output("#{bin}/jdupes --zeromatch .").strip.split("\n").sort
    assert_equal ["./a", "./b"], dupes
  end
end
