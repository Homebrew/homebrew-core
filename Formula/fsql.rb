class Fsql < Formula
  desc "Search through your filesystem with SQL-esque queries"
  homepage "https://github.com/kshvmdn/fsql"
  url "https://github.com/kshvmdn/fsql/archive/v0.3.1.tar.gz"
  sha256 "b88110426a60aa2c48f7b4e52e117a899d43d1bba2614346b729234cd4bd9184"

  bottle do
    cellar :any_skip_relocation
    sha256 "0636179071fe651a255182679921c1a9f7229e50a519005f65df74703c9500a2" => :mojave
    sha256 "9ac3de9b635d87b572c9dbc7d206105bab93768f2bdc081756477cea1340ff69" => :high_sierra
    sha256 "ef29b4aeaeb30416b1969391049f557c3c7edc5b818d41c1693f2f73639b42af" => :sierra
    sha256 "7cd4ee8016d85649bd0bbdc4ea24ab571d022d5e62b5f8e0d90d7ee6bbd4dd52" => :el_capitan
    sha256 "627a98cf5a27228b7f471b90925dbdc9734c9697c147f37767ae9572838dd984" => :yosemite
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
    cmd = "#{bin}/fsql SELECT FULLPATH\\(name\\) FROM foo"
    assert_match %r{^foo\s+foo/baz.txt$}, shell_output(cmd)
    cmd = "#{bin}/fsql SELECT name FROM . WHERE name = bar.txt"
    assert_equal "bar.txt", shell_output(cmd).chomp
    cmd = "#{bin}/fsql SELECT name FROM . WHERE FORMAT\\(size\, GB\\) \\> 500"
    assert_equal "", shell_output(cmd)
  end
end
