class Kubekey < Formula
  desc "Installer for Kubernetes and / or KubeSphere, and related cloud-native add-ons"
  homepage "https://kubesphere.io"
  url "https://github.com/kubesphere/kubekey.git",
      tag:      "v3.1.8",
      revision: "dbb1ee4aa1ecf0586565ff3374427d8a7d9b327b"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a1ba83756c233e0bc6fedcc8e9f0a7c074d578199b10b87260d9e56b15350ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "693464f5ce4a6fa53b4b611fc0fe365363bef1bab085d3d66c7a062a585a099e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "37d0f152897521ebd82ae11f18c8f3f4fb391542b553652112d9ceb41bedd260"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef3a31c0d6bc1ce05f1a122a57d785c0642601bb6a5b50b0b78702ba30551a99"
    sha256 cellar: :any_skip_relocation, ventura:       "be3affc1850b088364864c7051c32bd73ac509c8da2e039d73fbb43c1e38876c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f29bfdb3de576133ccbf0358e7cb49161720601d8fa04d47cfb8ca4bd7d115b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9acffe38490cd3e09d8e4a88ece233f65c1a1150e921fbcdd2751b563ef7e240"
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
    system "go", "build", *std_go_args(ldflags:, tags:, output: bin/"kk"), "./cmd/kk"

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
