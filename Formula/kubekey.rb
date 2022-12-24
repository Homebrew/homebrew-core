class Kubekey < Formula
  desc "Installer for Kubernetes and / or KubeSphere, and related cloud-native add-ons"
  homepage "https://kubesphere.io"
  url "https://github.com/kubesphere/kubekey.git",
      tag:      "v3.0.5",
      revision: "5efdd04e3e4976f3a33081dadef8d4beb1368905"
  license "Apache-2.0"
  head "https://github.com/kubesphere/kubekey.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0b98396ee5723c9cc67b703339e0b203b3f27345898d6e605c46d314fc409126"
    sha256 cellar: :any,                 arm64_monterey: "82ed717f6fb1ebab98692d8123d2bc75e8f2c0e3df88e959c82713869883da1c"
    sha256 cellar: :any,                 arm64_big_sur:  "2b455e13c17ef7381b7dafedfcd4edf41bb7de55aa802e87121899c2b7ed23fb"
    sha256 cellar: :any,                 ventura:        "f7989fa2c9a39761351a0c9dc17541d2fc5f09a6fd8d61dec56f153f6fdf480d"
    sha256 cellar: :any,                 monterey:       "299e3eafe45478f913d1c3997538ecbc6e158756c21819e8c212ce0595d01aa6"
    sha256 cellar: :any,                 big_sur:        "d426aa8b3967568e99ac4798265bb9f751921bccbf343585a41deac8d5285b89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8f979f4f3d1aa756c8071af761be6a6a60e7ce02c6592994723768df1d8bb97"
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
