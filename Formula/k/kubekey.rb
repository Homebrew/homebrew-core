class Kubekey < Formula
  desc "Installer for Kubernetes and / or KubeSphere, and related cloud-native add-ons"
  homepage "https://kubesphere.io"
  url "https://github.com/kubesphere/kubekey.git",
      tag:      "v3.1.6",
      revision: "5cad5b5357e80fee211faed743c8f9d452c13b5b"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3427fe99d6c53b465e3fb1bd0d0fe8fe56517b357be871a0b09f9e31f1dbc70c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "04f8788ac66545a2f38ed1246e06ad07cec31a2ec72025163e285e24e700031a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ade4752ff835dacd2be037bdf9dfe413ad590e2073430ef9ab1c43128269dd7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aed5735fda315a782158af6943e0998cb8e843e62d5a4ddd6e151f3d387030ca"
    sha256 cellar: :any_skip_relocation, sonoma:         "53fdc62b696235d765b0466ba7814f909445ed78475de0286e7e25c9bce52a56"
    sha256 cellar: :any_skip_relocation, ventura:        "e8e63b2f6a64ef4ba41c2819338972da25e1e749ba8c807cca090fc7decdad79"
    sha256 cellar: :any_skip_relocation, monterey:       "129e1e562f9560278b3c16612cbfcbda6d677c6084640fd3630cfeac9e25f615"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "123c0b6db59e01d39cfcea2f5ff0b649b3ebc43496126adac661656f1c986b3c"
  end

  depends_on "go" => :build
  depends_on "gpgme"

  on_linux do
    depends_on "pkg-config" => :build
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

    generate_completions_from_executable(bin/"kk", "completion", "--type", shells: [:bash, :zsh], base_name: "kk")
  end

  test do
    version_output = shell_output(bin/"kk version")
    assert_match "Version:\"v#{version}\"", version_output
    assert_match "GitTreeState:\"clean\"", version_output

    system bin/"kk", "create", "config", "-f", "homebrew.yaml"
    assert_predicate testpath/"homebrew.yaml", :exist?
  end
end
