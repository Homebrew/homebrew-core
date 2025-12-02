class Fsql < Formula
  desc "Search through your filesystem with SQL-esque queries"
  homepage "https://github.com/kashav/fsql"
  url "https://github.com/kashav/fsql/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "21f12261516bfa2ebc4136b7e7e08a23743809e847dfdace3c1f6ac88023277d"
  license "MIT"
  head "https://github.com/kashav/fsql.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "5bdd84069df7b3ffd2cf42cb36eff7f7c4bf7925494739d0af8b62ff5adbae16"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5ee1ef5c0cb7992fcdab0ab9ea54dd4fe8c5dbef39793a44d7a2d2a74a7bd6a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "01fa06d949f379122e16e504381653f59e3eb6ed941a8a929e276142f30bb64a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "01fa06d949f379122e16e504381653f59e3eb6ed941a8a929e276142f30bb64a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01fa06d949f379122e16e504381653f59e3eb6ed941a8a929e276142f30bb64a"
    sha256 cellar: :any_skip_relocation, sonoma:         "7e28627b044505df74811b404a61d49864b653834b4dc66be7a9a81abbaae3dd"
    sha256 cellar: :any_skip_relocation, ventura:        "7e28627b044505df74811b404a61d49864b653834b4dc66be7a9a81abbaae3dd"
    sha256 cellar: :any_skip_relocation, monterey:       "7e28627b044505df74811b404a61d49864b653834b4dc66be7a9a81abbaae3dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "bc30d152243d3fc0bc9f7e3bc02c71646dbc6b43c770d5b0d8d6bd4f6a463e36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2eb74fbbc15dd391cebadef0d2b51591dd76b8ff2892b4c93e6754efa1e6526d"
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
    assert_empty shell_output(cmd)
  end
end
