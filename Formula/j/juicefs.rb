class Juicefs < Formula
  desc "Cloud-based, distributed POSIX file system built on top of Redis and S3"
  homepage "https://juicefs.com"
  url "https://github.com/juicedata/juicefs/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "df779a718a608d47fdf1f3cd44c314d1cbc8fac43c4f862d2d40e768fecf0bb0"
  license "Apache-2.0"
  head "https://github.com/juicedata/juicefs.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2493bb7dbefe74ba5cc794be7b1be4e9f852b1d0b88d9172d0eb1a21f7e12c9e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a85e4f35a8d7717a777dd2c5f7b1701defdfb85cc2c90a89a3cd2ce936c08888"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3178719ffb87b807c54201bb4f36c585decbf360a285054078364574a3da2da2"
    sha256 cellar: :any_skip_relocation, sonoma:        "bdce438e5eebd604592b2f0dec06c1d41a95e8bcec7dd84674b96b258378b549"
    sha256 cellar: :any_skip_relocation, ventura:       "0e12d92f0b2715b3da58aeab1eb0a81c0e66b96df58477c97fed1b1a3aefe667"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6896e57ee0d71a126e081c76466e2467bc96901c83002c05bb0e034459940b04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "883d315f38a607476056341cb45c97c0f6f081dd3a447708c104ffc1ffd10f23"
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
