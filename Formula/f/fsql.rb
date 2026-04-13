class Fsql < Formula
  desc "Search through your filesystem with SQL-esque queries"
  homepage "https://github.com/kashav/fsql"
  url "https://github.com/kashav/fsql/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "21f12261516bfa2ebc4136b7e7e08a23743809e847dfdace3c1f6ac88023277d"
  license "MIT"
  head "https://github.com/kashav/fsql.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5998a7b21ebfca7e45beb100540c2c03e40b2a46fadd68f411f2d23ce94804d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5998a7b21ebfca7e45beb100540c2c03e40b2a46fadd68f411f2d23ce94804d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5998a7b21ebfca7e45beb100540c2c03e40b2a46fadd68f411f2d23ce94804d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "362bd94a4a9c87e587ea8bd66e5eb9343c7db121f9c0484fbcfdae8175f992d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fef8a76b6a6e113d05e3d2ffbc507da6aab473f01e95b9cdb95bd1ba5e03c5bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d3ac241c87450ec9515b9e98fd34a35cc5ebc77779af8575637834f6e9eddd8"
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
