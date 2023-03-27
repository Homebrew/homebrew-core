class Kubekey < Formula
  desc "Installer for Kubernetes and / or KubeSphere, and related cloud-native add-ons"
  homepage "https://kubesphere.io"
  url "https://github.com/kubesphere/kubekey.git",
      tag:      "v3.0.7",
      revision: "e755baf67198d565689d7207378174f429b508ba"
  license "Apache-2.0"
  head "https://github.com/kubesphere/kubekey.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6580a242182473353033307f3ced4327bacb67a65250b3bc59d6ffef4dc1adf1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53ba1bd7ce4a4e52763344aee9c1e8137c486797aacfbe9a3ef493e7cece1692"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "671a555ab1b319d94e3104e8c826e1687ace5cef99877d5d718f214d2c302a56"
    sha256 cellar: :any_skip_relocation, ventura:        "4ebd0c600f3fb755a26fa132373ab5ed071f402ba1f59b4badae7bbe7e18ce54"
    sha256 cellar: :any_skip_relocation, monterey:       "dae8b4da8caf67d3410b2db2983164883ab89b9f35ca060fd172993a4c4b3137"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d371cafa655b8d61a9054a03abb3b60cdd4744d5e8993969d694e96fb736c58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "458d227d0752402834ddd3a5dbab85571af9396b9f6dd8f284e347ff2d434fae"
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
