class Mage < Formula
  desc "Make/rake-like build tool using Go"
  homepage "https://magefile.org"
  url "https://github.com/magefile/mage.git",
      tag:      "v1.17.1",
      revision: "00dd13d9f6e84a3d212618dc1456cef0c661b231"
  license "Apache-2.0"
  head "https://github.com/magefile/mage.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b86c1d12ddf4a3243537779a577e842aca4b236c7d8202f140fd0d31d9b9d10"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b86c1d12ddf4a3243537779a577e842aca4b236c7d8202f140fd0d31d9b9d10"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b86c1d12ddf4a3243537779a577e842aca4b236c7d8202f140fd0d31d9b9d10"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd6567e6a710fb2000096e0d2421fa683a9eca5490dd8b24efd5f4c5c152f104"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "814b387fc7abe5f40947223bcce3f266b6286b2de046f5b8c9ba49d0992618f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3070fb30f4eb907ec1ee93fc777d6ca38185269845c886d4694ec0114e79526"
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
