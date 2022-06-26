class Fdupes < Formula
  desc "Identify or delete duplicate files"
  homepage "https://github.com/adrianlopezroche/fdupes"
  url "https://github.com/adrianlopezroche/fdupes/releases/download/v2.1.2/fdupes-2.1.2.tar.gz"
  sha256 "cd5cb53b6d898cf20f19b57b81114a5b263cc1149cd0da3104578b083b2837bd"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9b2c97111b7b420f99c521fce87023d4baaf49dcb03cb278cdfb774302b0ab2f"
    sha256 cellar: :any,                 arm64_big_sur:  "90adb098f4e20620d34970ac9a959ae70acf8437756e9c339ed58e35a9553a45"
    sha256 cellar: :any,                 monterey:       "8c79b738ca8a70384a764ee0a9f0163d7545ad0df3b41100d67a6d52b3fc619e"
    sha256 cellar: :any,                 big_sur:        "045b4c5514bf52f37e955a497b5b8356e1e7e4819e3ee6b67109cc9b8770362e"
    sha256 cellar: :any,                 catalina:       "e77144bd7d4b3ed472590b0bb7cb99dea185cf57b5b645bb0558c312441624c0"
    sha256 cellar: :any,                 mojave:         "d9504149274c97eb7edb268d43ff18ebd292046d4c5691ae7c7aa9d16b40b0b3"
    sha256 cellar: :any,                 high_sierra:    "0bd9b7c00c454042c485b1839ce6cef7f42af21710aa0d83f64a51ab5b18bfe2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf15c9f7944fb8a759bb16f42e2081b4e8f2372f6583f65f50701fa09d1b2a9b"
  end

  depends_on "pcre2"

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    touch "a"
    touch "b"

    dupes = shell_output("#{bin}/fdupes .").strip.split("\n").sort
    assert_equal ["./a", "./b"], dupes
  end
end
