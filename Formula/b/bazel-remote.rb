class BazelRemote < Formula
  desc "Remote cache for Bazel"
  homepage "https://github.com/buchgr/bazel-remote/"
  url "https://github.com/buchgr/bazel-remote/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "12048b619ea0eb8a1b7586755980fb2ee63763447ccba442f258c498de32dc83"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6992f127e2ee220cd6ce7bc75fe4ccd8db681c758c31928d3c8bece4147bb371"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a06b18ea04d87c8b87d028a140cd4b08cd67bcd2ed34224378451c0bf213391"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "883f5650b0e22ee8511fad69ea4837ed67e4457db0d66a481ee0926edf136f03"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e20ef2a28959eb449397ee99164c0b36e2189f82dccfd11ed65d93ac0ecc94c"
    sha256 cellar: :any_skip_relocation, ventura:       "8072cda8b7c29cec05be8ed7cd66b2bb7d8507541bf492f7d84fcda65d8c246b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b467edaa8556aa76bd3a1e8e6962a6074bc100cdcd8a44dfeaff86fdd5340e40"
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
