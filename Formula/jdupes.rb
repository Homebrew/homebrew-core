class Jdupes < Formula
  desc "Duplicate file finder and an enhanced fork of 'fdupes'"
  homepage "https://github.com/jbruchon/jdupes"
  url "https://github.com/jbruchon/jdupes/archive/v1.17.1.tar.gz"
  sha256 "e16858c91d7f58b2778ba16aef582a33cca208ce3b8e6ddafa591a81e82d3473"

  bottle do
    cellar :any_skip_relocation
    sha256 "a5c2f627d9f5d754db93194602d00809fa51d42bbe099c90d1b958505857649f" => :catalina
    sha256 "227031566f85278bae1f371f2143833c384110a40ca17b59b54198dee74be2cc" => :mojave
    sha256 "89f552a562c2d099f6b4b4ac84146687d58ca7b38622f7e0665b31bc786bd468" => :high_sierra
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
