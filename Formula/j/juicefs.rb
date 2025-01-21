class Juicefs < Formula
  desc "Cloud-based, distributed POSIX file system built on top of Redis and S3"
  homepage "https://juicefs.com"
  url "https://github.com/juicedata/juicefs/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "44aa8933887a237d5a69af84366d9cabe3eff025beabed19b57353fd941c2e45"
  license "Apache-2.0"
  head "https://github.com/juicedata/juicefs.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0511b17a82dba189a74abcdacf3877c3298397188cb6284c41b15f89b4a8f8c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ef807478563c3ecec0cd4b4ea91d0bb3f1ea85ae1a48ed00aa0475c10e47ab1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f5852636200c9c7d60026c6f23ced75986601e7806a4c5c166b70384e6223ee5"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa9d00a712fff0e8c9ef0c12cb0407cfb60a27a90b3b71c0ed653823979e7a9f"
    sha256 cellar: :any_skip_relocation, ventura:       "14ff5640d41e364088ef3f63a7b3cd5732329bcb8ad606b159738552405e7182"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67bbb702c83dfdcf6b3ac992b760d161e4690d75c01aa1feea6a637da7f8b1e5"
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
