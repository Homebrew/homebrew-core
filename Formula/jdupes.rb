class Jdupes < Formula
  desc "Duplicate file finder and an enhanced fork of 'fdupes'"
  homepage "https://github.com/jbruchon/jdupes"
  url "https://github.com/jbruchon/jdupes.git", :using => :git, :tag => "v1.9", :revision => "ba505f2a5462fc851e6d9f8a558a427eed1187c1"

  def install
    system "make"
    bin.install "jdupes"
    man1.install "jdupes.1"
  end

  test do
    touch "a"
    touch "b"

    dupes = shell_output("#{bin}/jdupes -z .").strip.split("\n").sort
    assert_equal ["./a", "./b"], dupes
  end
end
