class Jdupes < Formula
  desc "Duplicate file finder and an enhanced fork of 'fdupes'"
  homepage "https://github.com/jbruchon/jdupes"
  url "https://github.com/jbruchon/jdupes/archive/v1.13.2.tar.gz"
  sha256 "41376ace274320a77e35ffed170ff0cbca2cd0cfd0ff1cea53d7464e97d4341f"

  bottle do
    cellar :any_skip_relocation
    sha256 "ca9779c954693349118bf199c870c172a949ffda3b9089ff39de8acca91fa254" => :mojave
    sha256 "a43f89cbb3841755161ecc125d78f9d54a378536eeee8f81832ca29794ae3b2a" => :high_sierra
    sha256 "0f72269d74ce573b6ae1296f91f70450ffecd01ec640c4b8f7e3adb06bc4a8f1" => :sierra
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
