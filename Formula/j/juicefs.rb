class Juicefs < Formula
  desc "Cloud-based, distributed POSIX file system built on top of Redis and S3"
  homepage "https://juicefs.com"
  url "https://github.com/juicedata/juicefs/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "c64ebb28212840d12e37baaa1046d8226a3074427946c697a5ed22f158055758"
  license "Apache-2.0"
  head "https://github.com/juicedata/juicefs.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd9c876eb2d8f942b9bb4dac5cb73709eb7b193a26614e9fa26a87128bb33ea7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89a18b5d80d805cc75ebb808f6c28e7d27b85fef72b2ef05e5a5eb636fcc2b9c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e0f93d8257da27e7aae0b4d1a43f801684fc20c0144ac4a89bc2a14a8e54817"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d4a0daa16c664aa14086340897e944c6b2fc317706875e03e8a4a25b56d7637"
    sha256 cellar: :any,                 arm64_linux:   "387423223ed27fd7ef07001eeb31604bfb54976a8d4c648ae3a1fb567baea068"
    sha256 cellar: :any,                 x86_64_linux:  "a4f5ccc3afcda7ebe4f48f887f589792a81825ec80553855a2aa2c6c16e90195"
  end

  depends_on "go" => :build

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
