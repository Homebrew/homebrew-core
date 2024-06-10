class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://github.com/coder/coder/archive/refs/tags/v2.11.2.tar.gz"
  sha256 "a31db16dfe7b6da82c2f2e881d3bb9ebc9ccfbf4f1454f9692bd69f38b893471"
  license "AGPL-3.0-only"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cb5bf938305d7e2623cddb7e19af14c803d30787ab40e134e4e3cb1ca41eae8c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "972881dde0f1a31325859b09ca0ad258c8f2cacf78a320b0d8b3c89d17687016"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3eb1ab6758053c625749b42b7b72b2ab31b17de87244d64910b77338788e8f3b"
    sha256 cellar: :any_skip_relocation, sonoma:         "d5c6601bbf4f1cbd4673e30c220baff5a16c9cc79b45f66a183ab6c9d3dc0165"
    sha256 cellar: :any_skip_relocation, ventura:        "4c171e9ed7da527adee34b52f7db5c2a2a5b9107dcf1323eab7e95af9573b6c9"
    sha256 cellar: :any_skip_relocation, monterey:       "f7d58839476e9b406f61e707eef652444a5fd62baa2e55c75d24a0ffef98e13f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "127c5d55a38b6d97c6f8364ee475c6ca46dc76a28759d2bc42adb19e32e8115a"
  end

  depends_on "go@1.21" => :build # see https://github.com/coder/coder/issues/11342

  def install
    ldflags = %W[
      -s -w
      -X github.com/coder/coder/v2/buildinfo.tag=#{version}
      -X github.com/coder/coder/v2/buildinfo.agpl=true
    ]
    system "go", "build", *std_go_args(ldflags:), "-tags", "slim", "./cmd/coder"
  end

  test do
    version_output = shell_output("#{bin}/coder version")
    assert_match version.to_s, version_output
    assert_match "AGPL", version_output
    assert_match "Slim build", version_output

    assert_match "You are not logged in", shell_output("#{bin}/coder netcheck 2>&1", 1)
  end
end
