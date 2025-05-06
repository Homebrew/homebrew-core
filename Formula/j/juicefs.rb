class Juicefs < Formula
  desc "Cloud-based, distributed POSIX file system built on top of Redis and S3"
  homepage "https://juicefs.com"
  url "https://github.com/juicedata/juicefs/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "a29145a17deed9b753ad2a48e779bee1d5b17e39980317039bacb089d1c1c85c"
  license "Apache-2.0"
  head "https://github.com/juicedata/juicefs.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93d6b6b234746b745ed9875b75b33761e7c816d1aa2d623c71728c6b7bf27097"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a06e6e368690d5b35fbeb088abdb73211e192333fb34996c296a27c2ac10860e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8341307ec2aa713208726abbe0ed2cb3b85d80d185834592fb46e64b7286e2b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "f91870ae7f84be5ccbe478b60000e7067ef9c86ee8b39f8bc6566a7e01531dcf"
    sha256 cellar: :any_skip_relocation, ventura:       "a605622dbbe72e1fba6c22f09ee1a88cd23e9de73edc2c7129fc4da9b80bb61c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38d6bafea8444498f5b639a953c2c8b32087619915197275f9803c0516cce597"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb7e512f60b0e0d1cc328b7977ce081c3d02567db4bb1d9c98525417e7ae85ab"
  end

  depends_on "go" => :build

  def install
    system "make"
    bin.install "juicefs"
  end

  test do
    output = shell_output("#{bin}/juicefs format sqlite3://test.db testfs 2>&1")
    assert_path_exists testpath/"test.db"
    assert_match "Meta address: sqlite3://test.db", output
  end
end
