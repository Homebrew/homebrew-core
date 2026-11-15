class Juicefs < Formula
  desc "Cloud-based, distributed POSIX file system built on top of Redis and S3"
  homepage "https://juicefs.com"
  url "https://github.com/juicedata/juicefs/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "d398e39c4545b63685aa8846fb8847d3f5f37c93ea8436e49f6cf19d16e8091c"
  license "Apache-2.0"
  head "https://github.com/juicedata/juicefs.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fda4fb4547389e820a68d21770722446d7192a4df499adfba4d6e9381c446c73"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "75930146352b0adf4b15733d71b3495810e2eb35dafc938d749d6e767165d94c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "af0a80a731e611a2add9532899662c6e99f04463ba9080b4871d24a6dd2a8c0f"
    sha256 cellar: :any,                 arm64_linux:       "3179664dd63ee2b415d447b12792f206b303530a74cf112490fa8f6310a93936"
    sha256 cellar: :any,                 x86_64_linux:      "2ab94d8b7fd498c03e803d4166203a01bb7ce21214455ee9d37138b68cdd6e99"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    system "make"
    bin.install "juicefs"
  end

  test do
    output = shell_output("#{bin}/juicefs format sqlite3://test.db testfs 2>&1")
    assert_path_exists testpath/"test.db"
    assert_match "Meta address: sqlite3://test.db", output
  end
end
