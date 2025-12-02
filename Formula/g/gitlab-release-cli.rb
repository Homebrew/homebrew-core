class GitlabReleaseCli < Formula
  desc "Toolset to create, retrieve and update releases on GitLab"
  homepage "https://gitlab.com/gitlab-org/release-cli"
  url "https://gitlab.com/gitlab-org/release-cli/-/archive/v0.24.0/release-cli-v0.24.0.tar.bz2"
  sha256 "e13a53fdaf60e2fb2df620969dd35131800cddad8d3d4c476154110249629daa"
  license "MIT"
  head "https://gitlab.com/gitlab-org/release-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae973f1eb71e6e7adec764c889d3fa8a05ef399aef1674ec67919f52eccba9df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "876a3ed04ff07b0316bec9ff3f7979b473080ecb754b3751e0210994cd04a9bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "876a3ed04ff07b0316bec9ff3f7979b473080ecb754b3751e0210994cd04a9bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "876a3ed04ff07b0316bec9ff3f7979b473080ecb754b3751e0210994cd04a9bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "5480d1281a3356e1ddb811a9b4a6634969286682e14366641166a30c150d8202"
    sha256 cellar: :any_skip_relocation, ventura:       "5480d1281a3356e1ddb811a9b4a6634969286682e14366641166a30c150d8202"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14c1c3d4f20395d7ccd252126c1db2517441269591cce2205645adb6ee33616b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21aed32d1e61d02a7c6b3b5d111df239e576a3f5eeb82795ef150c5f3f8bc741"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.VERSION=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"release-cli"), "./cmd/release-cli"
  end

  test do
    ENV["CI_SERVER_URL"] = "https://gitlab.com"
    ENV["CI_PROJECT_ID"] = "12345678"

    assert_match version.to_s, shell_output("#{bin}/release-cli --version")

    output = shell_output("#{bin}/release-cli create --tag-name v1.0.0 2>&1", 1)
    assert_match "failed to create GitLab client: access token not provided", output
  end
end
