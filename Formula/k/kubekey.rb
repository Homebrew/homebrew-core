class Kubekey < Formula
  desc "Installer for Kubernetes and / or KubeSphere, and related cloud-native add-ons"
  homepage "https://kubesphere.io"
  url "https://github.com/kubesphere/kubekey.git",
      tag:      "v4.0.4",
      revision: "254b4ff4ec3aead30270f3fa82d8ac2d5b069eab"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5075a00df9944fa4e2564e2511b92d8f2d34912c72d307e95eb4f101eb4b574"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5785f76e03fc0a5b1bbe538ab311944658f43de86e1575c7561ffe99b9fbd5da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dbbe25cfbafbae2dd7e8aa5b52b1b12d4adc7b74f9b2bd7b82c5a0e3afb968aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f6cef3564caab2e37fda7482ffe512b39779b281094160ec68eb2dfcc900653"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb291fe15a6d247fbb2a7279bd561542735bad12d0e5122189a3d4c24d109f43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b16572376755b88b6614337c171c549e1c42a34670e93f934944b2f3afc4fd92"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "gpgme"

  on_linux do
    depends_on "btrfs-progs"
    depends_on "device-mapper"
  end

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
