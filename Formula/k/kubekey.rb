class Kubekey < Formula
  desc "Installer for Kubernetes and / or KubeSphere, and related cloud-native add-ons"
  homepage "https://kubesphere.io"
  url "https://github.com/kubesphere/kubekey.git",
      tag:      "v3.1.11",
      revision: "f9d473060ec34cd8ffe5a87f2eceb1dead397f5c"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62deda7ff4490da5db9057e8d1e4635317df2005d620d7dd1b2cefa69a19639a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "648ea4d70c883e8db01cc5db82879357b9b100fcdc320cba1d04116ab589fc5c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f3bb23bec12c8c67ccad9e4febd73031ee5235a5c8561e45ff41e72486df41d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c157465c57554f81de4ac425b41a74f436dd15c717002bf2e7886ac9fcefbe6d"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a74a8e89850ab3c2d64c9dd891b485642815e303c79756d847165cc74c8f076"
    sha256 cellar: :any_skip_relocation, ventura:       "fc04f16c027fc87e9b2bbdbc383af164e6b5dfdf34b1711ae094daa51fe0c2df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75123a2970434541625df59998b0138b208b5c6a8095a19989de1be00b4a5524"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e00317f35c2388fffc69731bf4184ab353bb397381cb6d9951bcc865b7f84643"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "gpgme"

  on_linux do
    depends_on "btrfs-progs"
    depends_on "device-mapper"
  end

  # patch for macos build failure, upstream pr ref, https://github.com/kubesphere/kubekey/pull/2744
  patch do
    url "https://github.com/kubesphere/kubekey/commit/01e23d7fc422d9b77a8a4a5581a4e3b3e1a64c95.patch?full_index=1"
    sha256 "57cc282c8282198a59586ae0d75cded669af5e79b6b473bbb870aa0083bd0e80"
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
    version_output = shell_output("#{bin}/kk version")
    assert_match "Version:\"v#{version}\"", version_output
    assert_match "GitTreeState:\"clean\"", version_output

    system bin/"kk", "create", "config", "-f", "homebrew.yaml"
    assert_path_exists testpath/"homebrew.yaml"
  end
end
