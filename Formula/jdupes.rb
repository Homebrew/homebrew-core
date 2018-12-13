class Jdupes < Formula
  desc "Duplicate file finder and an enhanced fork of 'fdupes'"
  homepage "https://github.com/jbruchon/jdupes"
  url "https://github.com/jbruchon/jdupes/archive/v1.11.1.tar.gz"
  sha256 "e71aef9a71ad038092416de48acbe57ac2f46ff13b710991a151caab3de4f7c8"

  bottle do
    cellar :any_skip_relocation
    sha256 "2adf7e4d8aec28f97bc668c5507e96fb0fb33efc4cfde479e8a8e34ba308d1e9" => :mojave
    sha256 "d16a5dbc7f93cd50f14a1da7572ec6283cf098c12a4331c25070f03284f22251" => :high_sierra
    sha256 "4632167d7896018dad5a016a3f7e6a420fc4d7bc02a36e3e727477272cfe0c3c" => :sierra
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
