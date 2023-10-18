class Juicefs < Formula
  desc "Cloud-based, distributed POSIX file system built on top of Redis and S3"
  homepage "https://juicefs.com"
  url "https://github.com/juicedata/juicefs/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "21df8049ddc02dbcb732c7a2fff3ad5e0dca71c7f568bb34a36e35f14c218397"
  license "Apache-2.0"
  head "https://github.com/juicedata/juicefs.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "26ab09e158117d83499a5d1c0b1eee80de2a78c4886af61031dc6ddbf901d0fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4f2b828411be54759b68bd2c35de73e62c7a3765105d570e4d34ac2c97e119f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "723faba5b5a34649ef5c1eb6f46c773d4c3c83e93666995bde959488644e13a4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9bedcf875761f5442e08350bba29d9ee202f995efe706cfc3d3ac573a9a1e7be"
    sha256 cellar: :any_skip_relocation, sonoma:         "0ad5d208b8db05455ec5f87d1675936141e58c88c73d60c85c3ce2836e205388"
    sha256 cellar: :any_skip_relocation, ventura:        "3022581aff6b242a1a57a23d0819c8aaf563ff1c7da9e23f99812dcd67c7bf5c"
    sha256 cellar: :any_skip_relocation, monterey:       "dd007211ad22407b11a7bc7ebc75bcad01d0b2d06eec5f21d2084df9c205894a"
    sha256 cellar: :any_skip_relocation, big_sur:        "49c6aa4b817dace8f5fd14644061889c1bcdbc4ef568ec62f587a9f411c9ec63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fc4b1c0bb4ee1cdf045b5897c47cd963a624f4711aa308a861908ce6b8564fd"
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
