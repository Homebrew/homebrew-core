class Fsql < Formula
  desc "Search through your filesystem with SQL-esque queries."
  homepage "https://github.com/kshvmdn/fsql"
  url "https://github.com/kshvmdn/fsql/archive/v0.3.0.tar.gz"
  sha256 "8dafa4680e6f72e1f0a52de7b0cd683de533db4635569de2a35a7122091325f7"

  bottle do
    cellar :any_skip_relocation
    sha256 "a794c99869d7819cc8eb34eb6121812926adbec40400372680a915f22cf2b932" => :sierra
    sha256 "83325a2daca987ef1f0d9b7edfa78df7a685efe038f62a095d3fb1930e313d89" => :el_capitan
    sha256 "500c729d69ba2e0680e4d9bacd642e427e87bdaa73f56c07ddd8ba2dbffe5636" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/kshvmdn").mkpath
    ln_s buildpath, buildpath/"src/github.com/kshvmdn/fsql"
    system "go", "build", "-o", bin/"fsql", "github.com/kshvmdn/fsql/cmd/fsql"
  end

  test do
    (testpath/"bar.txt").write("hello")
    (testpath/"foo/baz.txt").write("world")
    expected = <<-EOS.undent
      foo
      foo/baz.txt
    EOS
    cmd = "#{bin}/fsql SELECT FULLPATH\\(name\\) FROM foo"
    assert_equal expected, shell_output(cmd)
    cmd = "#{bin}/fsql SELECT name FROM . WHERE name = bar.txt"
    assert_equal "bar.txt", shell_output(cmd).chomp
    cmd = "#{bin}/fsql SELECT name FROM . WHERE FORMAT\\(size\, GB\\) \\> 500"
    assert_equal "", shell_output(cmd)
  end
end
