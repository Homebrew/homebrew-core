class Jdupes < Formula
  desc "Duplicate file finder and an enhanced fork of 'fdupes'"
  homepage "https://github.com/jbruchon/jdupes"
  url "https://github.com/jbruchon/jdupes/archive/v1.11.1.tar.gz"
  sha256 "e71aef9a71ad038092416de48acbe57ac2f46ff13b710991a151caab3de4f7c8"

  bottle do
    cellar :any_skip_relocation
    sha256 "a9ee8f7fb66b024c8cec3685a640e89f46a5278b9ad8fde1a927b4e30bcc1b0e" => :mojave
    sha256 "6844a3f7f308b8d39da723552aa9cbddd6f9a3bd13b0f9e72020c57f6edeba35" => :high_sierra
    sha256 "20e44eecc7a8066022338e0932163d1fcdc5b833fefde045406f5314609e2ee2" => :sierra
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
