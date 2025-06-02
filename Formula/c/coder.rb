class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://github.com/coder/coder/archive/refs/tags/v2.21.3.tar.gz"
  sha256 "8c4c27c02a7b0088f5194a1eba7e6be4cb61fb244e1926d4bb54eb6ab9fc1996"
  license "AGPL-3.0-only"
  head "https://github.com/coder/coder.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a499f79d10981f37fc1dd33308a807be6c0a1c5efc94f2b723d5876c8d00798"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6941f4d567e39d46b80dd052e893db887e4ba5b548b6a3fbee0f166b153e62cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "809840a048a98b4fb44df2be9d60c72c12c6743037cd9a70370627a4d5facb93"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a4997ba5a6709319758227d2040df049ab0bd6ab27a2615a5c52669100e3390"
    sha256 cellar: :any_skip_relocation, ventura:       "3926d09efa43cee20f5e93238687604222a141cd96b3f993b41505d840add2fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5cf7f1588ce2e34d5b0e2a2a255936a000e5d9b78a18027fd29abfacae238ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12f4febb2e71a6b4450ece38b38c9b71e1c0b8c29f0ca5468c11814a6d12fb87"
  end

  depends_on "go" => :build

  # purego build patch, upstream pr ref, https://github.com/coder/coder/pull/18021
  patch do
    url "https://github.com/coder/coder/commit/e3915cb199a05a21a6dd17b525068a6cb5949d65.patch?full_index=1"
    sha256 "ec0f27618f69d867ecc04c8eae648eca188e4db5b1d27e1d6bcc1bde64383cdf"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/coder/coder/v2/buildinfo.tag=#{version}
      -X github.com/coder/coder/v2/buildinfo.agpl=true
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "slim"), "./cmd/coder"
  end

  test do
    version_output = shell_output("#{bin}/coder version")
    assert_match version.to_s, version_output
    assert_match "AGPL", version_output
    assert_match "Slim build", version_output

    assert_match "You are not logged in", shell_output("#{bin}/coder netcheck 2>&1", 1)
  end
end
