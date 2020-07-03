class Jdupes < Formula
  desc "Duplicate file finder and an enhanced fork of 'fdupes'"
  homepage "https://github.com/jbruchon/jdupes"
  url "https://github.com/jbruchon/jdupes/archive/v1.17.1.tar.gz"
  sha256 "e16858c91d7f58b2778ba16aef582a33cca208ce3b8e6ddafa591a81e82d3473"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "459dcb9935d2de0dc27129398795174c0500a9e0ef3f6f69ec577ca1f7d56cb4" => :catalina
    sha256 "fe2d7466bc03ada0e62fb461a70b2940ab30eca1b3fe1a7e6ca22c4a8d5834a5" => :mojave
    sha256 "e3d37de30ad3462031394ac3b58562b5ede17bf2380ea43c0b32c5525ea15659" => :high_sierra
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "ENABLE_DEDUPE=1"
  end

  test do
    touch "a"
    touch "b"
    (testpath/"c").write("unique file")
    dupes = shell_output("#{bin}/jdupes --zeromatch .").strip.split("\n").sort
    assert_equal ["./a", "./b"], dupes
  end
end
