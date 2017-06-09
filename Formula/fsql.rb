class Fsql < Formula
  desc "Search through your filesystem with SQL-esque queries."
  homepage "https://github.com/kshvmdn/fsql"
  url "https://github.com/kshvmdn/fsql/archive/v0.2.1.tar.gz"
  sha256 "def6ddd2f9a5f64bc03821223f760250eecb775762e848f37fb105cf0254ad1c"

  bottle do
    cellar :any_skip_relocation
    sha256 "bf46899434596282a5a7b93bf362d0ecb6cf59ae7442cd7e3c0fc4bd1a46b902" => :sierra
    sha256 "4bd39ff926ef47576e84de9423b7d04aedee8ae62c683641607a44700aa173f1" => :el_capitan
    sha256 "58bb2a0a759bf6ab236e52d3dae6ce4b7ac583446203d7c4d21eee20d3df77b7" => :yosemite
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
