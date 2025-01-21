class Kubekey < Formula
  desc "Installer for Kubernetes and / or KubeSphere, and related cloud-native add-ons"
  homepage "https://kubesphere.io"
  url "https://github.com/kubesphere/kubekey.git",
      tag:      "v3.1.7",
      revision: "da475c670813fc8a4dd3b1312aaa36e96ff01a1f"
  license "Apache-2.0"
  head "https://github.com/kubesphere/kubekey.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6938a693f600662a5c4b61d33baaf3109a838e32412effc527074f667d0f105c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e9ba7ec72f6a6efa195179b1647710c4dd108c1ca08e6ec4db6bb8defc9a14d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "193d5416a7f8fe32e5d5a46b8d24aca7c483fdf65ecc137375564717baf538f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "b157156497c851d22b2c22336cfa985517c20cdb0b2b0b495c06f55e3d66c894"
    sha256 cellar: :any_skip_relocation, ventura:       "c63ef067be391e3f56943343f416832207f81fcacd49d29ede45dd225587a599"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1bd0be711c47b38c605db45c25f6e3cbfe03c1d7d53efadb706eddeb252a2d7d"
  end

  depends_on "go" => :build
  depends_on "gpgme"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "btrfs-progs"
    depends_on "device-mapper"
  end

  def install
    tags = "exclude_graphdriver_devicemapper exclude_graphdriver_btrfs containers_image_openpgp"
    project = "github.com/kubesphere/kubekey/v3"
    ldflags = %W[
      -s -w
      -X #{project}/version.gitMajor=#{version.major}
      -X #{project}/version.gitMinor=#{version.minor}
      -X #{project}/version.gitVersion=v#{version}
      -X #{project}/version.gitCommit=#{Utils.git_head}
      -X #{project}/version.gitTreeState=clean
      -X #{project}/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"kk"), "-tags", tags, "./cmd/kk"

    generate_completions_from_executable(bin/"kk", "completion", "--type", shells: [:bash, :zsh])
  end

  test do
    version_output = shell_output(bin/"kk version")
    assert_match "Version:\"v#{version}\"", version_output
    assert_match "GitTreeState:\"clean\"", version_output

    system bin/"kk", "create", "config", "-f", "homebrew.yaml"
    assert_path_exists testpath/"homebrew.yaml"
  end
end
