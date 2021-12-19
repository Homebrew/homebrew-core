class Mage < Formula
  desc "Make/rake-like build tool using Go"
  homepage "https://magefile.org"
  url "https://github.com/magefile/mage.git",
      tag:      "v1.12.0",
      revision: "2f1ec406dfa856a4b8378ef837061abc2a0ce01b"
  license "Apache-2.0"
  head "https://github.com/magefile/mage.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a76f89e81261e2f223fa94dfe025d989809304a3236cfac36d6816c3f2932e56"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a76f89e81261e2f223fa94dfe025d989809304a3236cfac36d6816c3f2932e56"
    sha256 cellar: :any_skip_relocation, monterey:       "3fd75c25b71b64fc8a379a013bec915947b2584a1880060c8396b3d6eb5f5a40"
    sha256 cellar: :any_skip_relocation, big_sur:        "3fd75c25b71b64fc8a379a013bec915947b2584a1880060c8396b3d6eb5f5a40"
    sha256 cellar: :any_skip_relocation, catalina:       "3fd75c25b71b64fc8a379a013bec915947b2584a1880060c8396b3d6eb5f5a40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a271902ea09ef3318c350bea322817e8903a97b87069b124ea82069f49c8f81"
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
