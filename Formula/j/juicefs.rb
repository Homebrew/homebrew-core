class Juicefs < Formula
  desc "Cloud-based, distributed POSIX file system built on top of Redis and S3"
  homepage "https://juicefs.com"
  url "https://github.com/juicedata/juicefs/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "177917ee5646138e529f9890a311fecfcb89ee9d5fdc2e5aabf8c7ebacb014ba"
  license "Apache-2.0"
  head "https://github.com/juicedata/juicefs.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a5dafa90fb815c4302d2cdfcd1bb69a36b6ebf5c0c7d5851750dcf7925b5e745"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "320bec004a51c82faddff438289db703a7c6b10f1b227ed3d20b0433f215e25b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "51decfe8981c2c17d20565daa76bbdfb99d249f0548284be4e6f0e7c9cde2905"
    sha256 cellar: :any_skip_relocation, ventura:        "c7417547ea0c1b23c5c41ebe077b894c1c7479f2d654051d28309bcbda2d67ab"
    sha256 cellar: :any_skip_relocation, monterey:       "d10b231ecebe3c8a7e20ab0bc56c8558c86fe652ae003962fd75e09b909c6563"
    sha256 cellar: :any_skip_relocation, big_sur:        "8532620e401a4616cf2424d2f01b5ea0f59e3abfeb99d47c961d4be1e54d9d5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35f620ab1bbac5b35b76506bbd028a3b95347379cff1f07c602c49705c79f957"
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
