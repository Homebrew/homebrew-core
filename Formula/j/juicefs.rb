class Juicefs < Formula
  desc "Cloud-based, distributed POSIX file system built on top of Redis and S3"
  homepage "https://juicefs.com"
  url "https://github.com/juicedata/juicefs/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "3122b9f608bfdc6a477d73ec38b13c30ce6b07a09e046c61a37042153f35e0d3"
  license "Apache-2.0"
  head "https://github.com/juicedata/juicefs.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e3166c9013b38309f39ceb6a6a1fc274612d8d2c8913d05ea6e376cb698b35f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6654af21d8b0728dd136d95e5edd237405f6542366fc9ae30d1430e008ecb42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d34046f671926a4b20118b4f897ebd92b0db4409b91363f49551187fc640d080"
    sha256 cellar: :any_skip_relocation, sonoma:        "06e08a9570e57cdec98048c3774807c1d54be5c80e9721d3ca65c9e5e776c53e"
    sha256 cellar: :any,                 arm64_linux:   "9315c19afe1baeeffac41e625c4550570cdbc34867e129525f911f834b448e27"
    sha256 cellar: :any,                 x86_64_linux:  "d4c76484e4d79c84c012635245e5a6d318cfd388aed27a0c04d92e1f21fc12b9"
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
