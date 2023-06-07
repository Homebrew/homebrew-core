class Fsql < Formula
  desc "Search through your filesystem with SQL-esque queries"
  homepage "https://github.com/kashav/fsql"
  url "https://github.com/kashav/fsql/archive/v0.5.1.tar.gz"
  sha256 "743ab740e368f80fa7cb076679b8d72a5aa13c2a10e5c820608558ed1d7634bc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "417e28b2d563993b3271eb618a36d63613ec33dcdf641825a857201f32290b16"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9503bad9beef53afe723b7f108358387dbd27e6e95840b4bf1f05b417e26c554"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3152db0f493ffed00da1697927faf6d6abd5dd2507fc16522aa0880e989f938d"
    sha256 cellar: :any_skip_relocation, ventura:        "e9df3db0def1f9b2b7728947ab2b311dbfc5962e4f34e272ef5bc897712e296c"
    sha256 cellar: :any_skip_relocation, monterey:       "119db791efbfa4c293dbfefbcf3d06cc1e6513c77d4243fde6954aaa350aeb00"
    sha256 cellar: :any_skip_relocation, big_sur:        "51427ac84aead8115df46e52cb129d88007f6432b8b91c246a8775ae753e440e"
    sha256 cellar: :any_skip_relocation, catalina:       "727db2370d0a5de1ff0c03b0508c26a2cefa86c3f76d1fcf4d7cb3de3c76e36d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7ba18e8d272abf01631cc01913d8bad0c5795a367cd055f03154b0da41b6083"
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
    cmd = "#{bin}/fsql SELECT name FROM . WHERE FORMAT\\(size, GB\\) \\> 500"
    assert_equal "", shell_output(cmd)
  end
end
