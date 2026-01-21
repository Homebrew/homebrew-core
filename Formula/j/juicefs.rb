class Juicefs < Formula
  desc "Cloud-based, distributed POSIX file system built on top of Redis and S3"
  homepage "https://juicefs.com"
  url "https://github.com/juicedata/juicefs/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "37404fb9693a39d1e2ba8ec6323c1e3e1502852fd7eb04e10657f6cffe9ef110"
  license "Apache-2.0"
  head "https://github.com/juicedata/juicefs.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f5cd25c0034180ab9338373a5e278dfc5400fac7257cabf06b288899c602d960"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f83d44fd56ff4fd1b0cb4cc1696260ecc0906dab55b0f83f824fc6bb78da7cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2c137424d00035f136acbbdf7c391cd7cc6c498ac016190e5a3b403296aab8e"
    sha256 cellar: :any_skip_relocation, sonoma:        "3196e0bf833ae3ddfebc56def67968b4a0fa0f8b0f84b09d84d703ba168961df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ae9b27e1c37cbb2d71cb49d30735728f6ef2a2d4cd3effc6a348d5eeb7ee7fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7b195c808d249265774b78dac00fa69cbd6fcac11e6ce4d40ab9d0c9e26d4e0"
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
