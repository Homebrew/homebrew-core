class Kubekey < Formula
  desc "Installer for Kubernetes and / or KubeSphere, and related cloud-native add-ons"
  homepage "https://kubesphere.io"
  url "https://github.com/kubesphere/kubekey.git",
      tag:      "v3.1.10",
      revision: "cdc54e0986ed98997703b527a49f8bab2c0ee950"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8eb07536020c35c08b9c3c8e2e479a98860d19818f84ee0d4ec83aba64719486"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5dad9250063d8f04935e649383714f46644ee5e87f729120174add2277275af1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c341287bdc7285f60693d50d01ae45071920ebf615478a4de70ac5670aba472a"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e8c0998ad6da1eb3e8be84c1daadbc8ca6a117f8c7d8ca88426903e56596fc2"
    sha256 cellar: :any_skip_relocation, ventura:       "a7ce5d7d44e57ef773180018038a072c21a27e6bd9476a65ecbb8be9984ed273"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1dd737394f7d4cf1284ff1ab707503e73d875cfe0863877f4d14a46a480da7c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e68af1256d23f755f6d7409e05288c1ac654ceef987c4afa13ec5bb6b53eebf"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "gpgme"

  on_linux do
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
