class Kubekey < Formula
  desc "Installer for Kubernetes and / or KubeSphere, and related cloud-native add-ons"
  homepage "https://kubesphere.io"
  url "https://github.com/kubesphere/kubekey.git",
      tag:      "v3.0.10",
      revision: "3e381c6d5556117d132326b58c5177e0b0e839b6"
  license "Apache-2.0"
  head "https://github.com/kubesphere/kubekey.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df5abd69db8c19477b98457f3728035f61ac59e0c76a29844995c6f8c1bc0ade"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f2628c7abe7ec626e2f924e6827b8427c80e4398739d586b4e39d8e42f7b7af"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4cfdb70e66fe7654a740d53bd254cab567f4284a6c3943f816268abed9924203"
    sha256 cellar: :any_skip_relocation, ventura:        "c6e95697f291041c02080c6fcc6289cb901c1a283465b5eb9664e6a315930d87"
    sha256 cellar: :any_skip_relocation, monterey:       "8fd5cc74cb71d4787cece783261d8044cfe5790d7c0dbbcc91bad6a5651872e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "a31518f392706028bc3b2dbc04987c13505496d17d5fcf8390564aeb5590ea42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e92d18722a20a1be052fd525fe04024494fdd59363baad166fb4baac051d92d8"
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
