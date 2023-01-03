class Kubekey < Formula
  desc "Installer for Kubernetes and / or KubeSphere, and related cloud-native add-ons"
  homepage "https://kubesphere.io"
  url "https://github.com/kubesphere/kubekey.git",
      tag:      "v3.0.6",
      revision: "ec903fe13dfed73ffd3f72f4beec3123675ce4d0"
  license "Apache-2.0"
  head "https://github.com/kubesphere/kubekey.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6bc586b42508ac52ec0b436957bfede1554b250812917d366e5192d17b04bdb1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9dc18150d46d21e7e00351d0b43e55b7e4702172129e269734ad413e035922a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "08a742e3a173cc6486a8a0acf9af7d18b00c8b35a384fdc31339be04544222c1"
    sha256 cellar: :any_skip_relocation, ventura:        "ec91ab5394b4e84d32cc7fe05b17bfeb7aa99b2ce8c6c130f130ed6af384f9c9"
    sha256 cellar: :any_skip_relocation, monterey:       "ac341fb1d9f5dce28ffabd9a505eeeae54ee3db494fc32d2a1cdfd0a89e09cdb"
    sha256 cellar: :any_skip_relocation, big_sur:        "c39536be42538ee465594fbfebc59183c97637111e59bee8664780b43cd94b63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afa027dab7cc43a3d2cea770d0a0dab45a1f62dcb9e6eb1d2e928baf5daaddc0"
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
