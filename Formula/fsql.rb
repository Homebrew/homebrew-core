class Fsql < Formula
  desc "Search through your filesystem with SQL-esque queries."
  homepage "https://github.com/kshvmdn/fsql"
  url "https://github.com/kshvmdn/fsql/archive/v0.1.1.tar.gz"
  sha256 "d3ff000b8374d2eb9a44aa20220c758a82a24c82ee8a369fae146e84fc422f2c"

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
    system "go", "build", "-o", bin/"fsql"
  end

  test do
    (testpath/"bar.txt").write("hello")
    (testpath/"foo/baz.txt").write("world")
    expected = <<-EOS.undent
      foo
      foo/baz.txt
    EOS
    assert_equal expected, shell_output("#{bin}/fsql SELECT name FROM foo")
    output = shell_output("#{bin}/fsql SELECT name FROM . WHERE name = bar.txt")
    assert_equal "bar.txt", output.chomp
    output = shell_output("#{bin}/fsql SELECT all FROM . WHERE size \\> 500gb")
    assert_equal "", output
  end
end
