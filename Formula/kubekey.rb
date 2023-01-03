class Kubekey < Formula
  desc "Installer for Kubernetes and / or KubeSphere, and related cloud-native add-ons"
  homepage "https://kubesphere.io"
  url "https://github.com/kubesphere/kubekey.git",
      tag:      "v3.0.6",
      revision: "ec903fe13dfed73ffd3f72f4beec3123675ce4d0"
  license "Apache-2.0"
  head "https://github.com/kubesphere/kubekey.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9ca104c448e67685af0d3dd95753b591d0bc5fc7b14e8f725061b8316f6897e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8cc9e7ecc6748cdd20787f789d1d805fab8786cfa3ae7ff9d907fc738f7252c4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3db128d5346a6a931f5dff1af2b50480dda4516d5653829065d942f79f2e83d5"
    sha256 cellar: :any_skip_relocation, ventura:        "c7c7c49134962e27e786d9b671130c639dcb84973399923040359278ced57ab0"
    sha256 cellar: :any_skip_relocation, monterey:       "c832b691d8ccf8e85b247ba908207c61e260487ac3bcc553f5b5c64b14da14a8"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d67a893b55bbbfe86e27f8b5795e600a462e953df187ca8910fb85aaf41f0fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a13e01ef1d4fb54097e6a416e28c5d7dfeb2d3a46cffdfd483ce5b8bd6a91d23"
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
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"kk"), "-tags", tags, "./cmd/kk"

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
