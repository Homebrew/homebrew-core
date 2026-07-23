class Mage < Formula
  desc "Make/rake-like build tool using Go"
  homepage "https://magefile.org"
  url "https://github.com/magefile/mage.git",
      tag:      "v1.17.2",
      revision: "0953947c1673fd745a51c032aadeb3c63f9f3368"
  license "Apache-2.0"
  head "https://github.com/magefile/mage.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4bd5e578716ac74dd900c27728e12cabea8c7b52d505d5aa6e542530357d128"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4bd5e578716ac74dd900c27728e12cabea8c7b52d505d5aa6e542530357d128"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4bd5e578716ac74dd900c27728e12cabea8c7b52d505d5aa6e542530357d128"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e8357d038724c1ede8ef3b453ac4f88afad14cb47fc5e1392b9f1821b274493"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3f6e766bccf62f9bf72a9b75aa0fd79d3538c39b2377e8a8164e35c4db49a41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43d22223bcf08c76baa8481e3f7e77d77e66980de21067b1e2a9a6e4f9114ccb"
  end

  depends_on "go"

  def install
    ldflags = %W[
      -s -w
      -X github.com/magefile/mage/mage.timestamp=#{time.iso8601}
      -X github.com/magefile/mage/mage.commitHash=#{Utils.git_short_head}
      -X github.com/magefile/mage/mage.gitTag=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match "magefile.go created", shell_output("#{bin}/mage -init 2>&1")
    assert_path_exists testpath/"magefile.go"
  end
end
