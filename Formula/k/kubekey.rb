class Kubekey < Formula
  desc "Installer for Kubernetes and / or KubeSphere, and related cloud-native add-ons"
  homepage "https://kubesphere.io"
  url "https://github.com/kubesphere/kubekey.git",
      tag:      "v4.0.5",
      revision: "9c3c07659992c4054ee2ae204a1a8b17e1cbaf75"
  license "Apache-2.0"
  head "https://github.com/kubesphere/kubekey.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e2577a24f599b122bffa6888b2222c55f53487f5cdad4bcb1ae7d4c7af3a8335"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4d39566b3e880a4cd2008a96d478bca3cbec38aa23560356ebc95d9d939f93a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa60a74b8994eda146f687aee593cf4799850a3ac7e42723a30e22272f00adeb"
    sha256 cellar: :any_skip_relocation, sonoma:        "a10bf2c5c99895d410797acaf83b833547b1c81f1229a24ee26395d5a104c9a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92daa3cc59e0c491493900303349bf40186327be303f832e32e8762977ace786"
    sha256 cellar: :any,                 x86_64_linux:  "8dc73979747fd70f483afde498ea7549a865a174e8bbb830bd504084d3f08ed9"
  end

  depends_on "go" => :build

  def install
    project = "github.com/kubesphere/kubekey/v#{version.major}"
    ldflags = %W[
      -s -w
      -X #{project}/version.gitMajor=#{version.major}
      -X #{project}/version.gitMinor=#{version.minor}
      -X #{project}/version.gitVersion=v#{version}
      -X #{project}/version.gitCommit=#{Utils.git_head}
      -X #{project}/version.gitTreeState=clean
      -X #{project}/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "builtin", output: bin/"kk"), "./cmd/kk"

    generate_completions_from_executable(bin/"kk", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kk version 2>&1")
    assert_match "apiVersion: kubekey.kubesphere.io/v1", shell_output("#{bin}/kk create config")
  end
end
