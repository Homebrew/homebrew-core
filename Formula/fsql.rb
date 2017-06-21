class Fsql < Formula
  desc "Search through your filesystem with SQL-esque queries."
  homepage "https://github.com/kshvmdn/fsql"
  url "https://github.com/kshvmdn/fsql/archive/v0.3.0.tar.gz"
  sha256 "8dafa4680e6f72e1f0a52de7b0cd683de533db4635569de2a35a7122091325f7"

  bottle do
    cellar :any_skip_relocation
    sha256 "316420c1e4a7793fd5607b032be6b32ca67ed8851b53af9c3c410d65cca9a8a4" => :sierra
    sha256 "530a6013f87796b1b2bd99b6e36f12ec4dc762f8431f4536bcdffcbfddacba04" => :el_capitan
    sha256 "6869e98d96626f0b3eb25e89203ec08cd03468f833c7a0122e17c555d3181f4e" => :yosemite
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
