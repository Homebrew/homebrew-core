class Juicefs < Formula
  desc "Cloud-based, distributed POSIX file system built on top of Redis and S3"
  homepage "https://juicefs.com"
  url "https://github.com/juicedata/juicefs/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "2614424873065704d4ab63d3b4ecb831854b3f635709c56dc57ff1400e3cd962"
  license "Apache-2.0"
  head "https://github.com/juicedata/juicefs.git", branch: "main"

  depends_on "go" => :build

  def install
    system "make"
    bin.install "juicefs"
  end

  test do
    output = shell_output("#{bin}/juicefs format sqlite3://test.db testfs 2>&1")
    assert_predicate testpath/"test.db", :exist?
    assert_match "Meta address: sqlite3://test.db", output
  end
end
