class Mage < Formula
  desc "Make/rake-like build tool using Go"
  homepage "https://magefile.org"
  url "https://github.com/magefile/mage.git",
      tag:      "v1.13.0",
      revision: "3504e09d7fcfdeab6e70281edce5d5dfb205f31a"
  license "Apache-2.0"
  head "https://github.com/magefile/mage.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "582631a00f73b95e8e3d41b5409fbe6210e6f20c22977296ca430c8d16e80bc7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "582631a00f73b95e8e3d41b5409fbe6210e6f20c22977296ca430c8d16e80bc7"
    sha256 cellar: :any_skip_relocation, monterey:       "d2da91d98adad62480fb9efd3f311f0d56a5406772d3f5c0ac3af7cd5da0fd96"
    sha256 cellar: :any_skip_relocation, big_sur:        "d2da91d98adad62480fb9efd3f311f0d56a5406772d3f5c0ac3af7cd5da0fd96"
    sha256 cellar: :any_skip_relocation, catalina:       "d2da91d98adad62480fb9efd3f311f0d56a5406772d3f5c0ac3af7cd5da0fd96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ed02d4428c2c712929e78a1c51b8b20ff851e4cea12807607b0a82dcee0ebea"
  end

  depends_on "go"

  def install
    ldflags = %W[
      -s -w
      -X github.com/magefile/mage/mage.timestamp=#{time.rfc3339}
      -X github.com/magefile/mage/mage.commitHash=#{Utils.git_short_head}
      -X github.com/magefile/mage/mage.gitTag=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match "magefile.go created", shell_output("#{bin}/mage -init 2>&1")
    assert_predicate testpath/"magefile.go", :exist?
  end
end
