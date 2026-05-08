class Juju < Formula
  desc "DevOps management tool"
  homepage "https://canonical.com/juju"
  url "https://github.com/juju/juju/archive/refs/tags/v4.0.9.tar.gz"
  sha256 "4b0f2beeaa76fffdafb24b59412da43c12a3fcf8a7ef8066e266dca606e8da8c"
  license "AGPL-3.0-only"
  version_scheme 1
  head "https://github.com/juju/juju.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "235d6cf3a038bec05264800e22447e2861f786106bfffd9f8f3abb1c2d7c97c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26180a107ac045bb9d2e2d56fdd0c8ee7f5c369a450918c9e2ee4dbd6d627447"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8412b6638cefce562913b48e938144204bac7b24c71fd596ed8e4a209e88862d"
    sha256 cellar: :any_skip_relocation, sonoma:        "95e6d523a13b9da00a3ce8514db9f0f7df61821b87fa453a35589a72b6900d08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c226fe052233c7f2a37a1751334cd776dd614d152f77a6db9ab346c7fa82268"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1aa5b8ecc1089bbd3eab84b73941f605a74e3097fd49343e6d9a7141d87a5bdc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/juju"
    system "go", "build", *std_go_args(output: bin/"juju-metadata", ldflags: "-s -w"), "./cmd/plugins/juju-metadata"
    bash_completion.install "etc/bash_completion.d/juju"
  end

  test do
    system bin/"juju", "version"
    assert_match "No controllers registered", shell_output("#{bin}/juju list-users 2>&1", 1)
    assert_match "No controllers registered", shell_output("#{bin}/juju-metadata list-images 2>&1", 2)
  end
end
