class Juicefs < Formula
  desc "Cloud-based, distributed POSIX file system built on top of Redis and S3"
  homepage "https://juicefs.com"
  url "https://github.com/juicedata/juicefs/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "661cf04d83b06e676cbce7a33a37d742787b098c7703ed528b1456391b6017ec"
  license "Apache-2.0"
  head "https://github.com/juicedata/juicefs.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7364e9f8e89476f54479f460419011392303a88324807f15e9cee81644a5aded"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "680638d6f6ee73b901ae9715d5d44185bca029a64278a631c3b5576f76641304"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae9d1cd587a368ccfd28772f141adcc312547d5e748d6b61508736df9eb0d1cb"
    sha256 cellar: :any_skip_relocation, sonoma:         "3f80b36aeb015a5dfdefbb2984ef1668ca59768341e774636cd88114b2d41171"
    sha256 cellar: :any_skip_relocation, ventura:        "fe310a66e36b21baa75a461e6a7a487001af076a4b18b8034b46588e8d09c575"
    sha256 cellar: :any_skip_relocation, monterey:       "fd45c0afbd6ad801ef79c64fffc57bdf0ab1e962dcad844131a9289e1901d255"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2793ade0a368e8f43c2e2eb2f73ae1960722ca9378c9616f0f464428d5d81907"
  end

  # use "go" again after https://github.com/juicedata/juicefs/issues/5047 is resolved and released
  depends_on "go@1.22" => :build

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
