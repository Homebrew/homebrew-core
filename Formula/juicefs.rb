class Juicefs < Formula
  desc "Cloud-based, distributed POSIX file system built on top of Redis and S3"
  homepage "https://juicefs.com"
  url "https://github.com/juicedata/juicefs/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "2614424873065704d4ab63d3b4ecb831854b3f635709c56dc57ff1400e3cd962"
  license "Apache-2.0"
  head "https://github.com/juicedata/juicefs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1826898cc35b253aa6b9e6cff0d8effedfe041d96ffe32e90bc6311ff7772c2e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6bc6369331259d6fbb13b7d94d35d7b2bff6a960449a9befbe172c34bd6abc9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "94bfefc38bd89b10e8d814785e18f4a1f4f18899419020de8b575af2eb8e3c4d"
    sha256 cellar: :any_skip_relocation, ventura:        "bff78ae284933c07722460ae7443629d60128bce54dd7e4917526296d7193860"
    sha256 cellar: :any_skip_relocation, monterey:       "25b0e4df53be09d12369de745748112ef85ccf88116d74b7f6a1c5f2eedc5ff2"
    sha256 cellar: :any_skip_relocation, big_sur:        "ffcf64d849faa9b1f36bc0e9dfbeac0c5ffbfe3ba61093fb8e605e9eb5f1c787"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8dbe79a6f51aa71aa2434726dd1f96dcf7a8e5de7a10a889db2c744f68fcfa9b"
  end

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
