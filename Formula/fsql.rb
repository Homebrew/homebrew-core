class Fsql < Formula
  desc "Search through your filesystem with SQL-esque queries"
  homepage "https://github.com/kashav/fsql"
  url "https://github.com/kashav/fsql/archive/v0.4.0.tar.gz"
  sha256 "5f028446e31f1a8be2f8a72cd2c1ae888e748220e4c4ece38a62fd8fe41bf70a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d08ff0913536b1cd4b7116c27146e976442b255977de14003d1049dfc8e84aa1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "77ec663d81151aebf469db5626893d130ff21114f603227046999a27ea843f8f"
    sha256 cellar: :any_skip_relocation, monterey:       "eda303b91bc756145a51a374ffadc4862d7967c2358be1c3f0d544951390d13d"
    sha256 cellar: :any_skip_relocation, big_sur:        "53d773ca5cba807627e4e3b7cdb36990c18c3b1944c847756c1acf95d99d6af6"
    sha256 cellar: :any_skip_relocation, catalina:       "c97d021f2047654b1141141bfdaceba40953a39cc150233cb9ec3bb85ee9b675"
    sha256 cellar: :any_skip_relocation, mojave:         "5d984747c498019e9950c57084e2549417dce8206ab489650fcba917ad7a30af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f54460f0a2744214e28ad7a8d9ef8f583ca32a91bf60588cb2dc2cc467aff56"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/fsql"
  end

  test do
    (testpath/"bar.txt").write("hello")
    (testpath/"foo/baz.txt").write("world")
    cmd = "#{bin}/fsql SELECT FULLPATH\\(name\\) FROM foo"
    assert_match %r{^foo\s+foo/baz.txt$}, shell_output(cmd)
    cmd = "#{bin}/fsql SELECT name FROM . WHERE name = bar.txt"
    assert_equal "bar.txt", shell_output(cmd).chomp
    cmd = "#{bin}/fsql SELECT name FROM . WHERE FORMAT\\(size\, GB\\) \\> 500"
    assert_equal "", shell_output(cmd)
  end
end
