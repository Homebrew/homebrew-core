class Feishu2md < Formula
  desc "Convert feishu/larksuite documents to markdown"
  homepage "https://github.com/Wsine/feishu2md"
  url "https://github.com/Wsine/feishu2md/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "45f9cce470c591c59e933bb9db7227c41f13d86943ac9aa9f4761ad7fcb01adb"
  license "MIT"
  head "https://github.com/Wsine/feishu2md.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "98e48d18042397ff107c4d1af86c74ebf1299f6504f871e6c743452f70a8c571"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ecee1f1a1b4b97fafde291de8c71f2774d6db47ea0205313a839eae8a2a024bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7bb02ba3e358404ee4ed339aebd95c8f3a70d1bf0309fc769aea95c786d469ce"
    sha256 cellar: :any_skip_relocation, sonoma:         "32c5ea9391a2bb5ec066020e2dba1f2d79e254aad29fe1b828dc1a2c91d25a1e"
    sha256 cellar: :any_skip_relocation, ventura:        "42996a45718893e7508a665fb15a3394a845161467cbcc54c9026dd839140f50"
    sha256 cellar: :any_skip_relocation, monterey:       "c977bde773d7319749904a05389c03020bd02ef18803d4c642a3772d3d4de9e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "139d95d3f7d78dadcdf8752d4b4049c093d2f0ab86ba2a74263c3fd8b4cb2266"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd"
  end

  test do
    output = shell_output("#{bin}/feishu2md config --appId testAppId --appSecret testSecret")
    assert_match "testAppId", output

    assert_match version.to_s, shell_output("#{bin}/feishu2md --version")
  end
end
