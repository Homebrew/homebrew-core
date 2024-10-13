class BazelRemote < Formula
  desc "Remote cache for Bazel"
  homepage "https://github.com/buchgr/bazel-remote/"
  url "https://github.com/buchgr/bazel-remote/archive/refs/tags/v2.4.4.tar.gz"
  sha256 "f358997aa5c2b58e1d16a6acf5a6bb9797a8ee4d502ac7d3a00525d4edc6bad1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "725a245b501ff5917c629d8457fa44df82a3e20d68b675a1153790131a6da691"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2d02dc2fc9308975dcd8288bf20d2ce30d44d2df318b2b95de38871a3cd031cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68c09f83fdabd5e3a040ed6e60dfeb1c726e29881780f37916dd561bd6d22320"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4dee66da7e388f6c0c0b1418e1f36dd761ceafcd54ea5c2ba37415ab5d04fd93"
    sha256 cellar: :any_skip_relocation, sonoma:         "cff600263294a94d06bd0b2023fc5cde02fddeabf8859480d840e98bf386c090"
    sha256 cellar: :any_skip_relocation, ventura:        "282a91b95fab9d8c3db62eb8c278aa8fd94ed2c58734f9143110e6a2a8c12015"
    sha256 cellar: :any_skip_relocation, monterey:       "d23bfe3cdb81d81d89a4783a3535beda3b5ec2804f713851f37dea4073855ddf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "212ad6592ff22c1eb04d90a3ecc488637940a3ce54f92b026f23fad3829256da"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.gitCommit=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    ENV["BAZEL_REMOTE_DIR"] = "test"
    ENV["BAZEL_REMOTE_MAX_SIZE"] = "10"

    begin
      pid = fork { exec bin/"bazel-remote" }
      sleep 2
      assert_predicate testpath/"test", :exist?, "Failed to create test directory"
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
