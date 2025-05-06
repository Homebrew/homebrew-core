class Kubekey < Formula
  desc "Installer for Kubernetes and / or KubeSphere, and related cloud-native add-ons"
  homepage "https://kubesphere.io"
  url "https://github.com/kubesphere/kubekey.git",
      tag:      "v3.1.9",
      revision: "f7f74890ec51db1e4c35b54af8ecc87d7f807deb"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34911d6cbc0a8ef3df9777103ce7ff8a54a192be3952649950df9562ac3463c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33571c95cfcc2aa8faae95c7b02686b500dd8b7aa424a2f60641a190e615225f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d89ea31c4a8a5ebc0c335e22a644244dfd3ba027233d092d9428dfc2d33f8175"
    sha256 cellar: :any_skip_relocation, sonoma:        "2606d1eeaa6809dd66d79e638a298986c2c4c7c2f914006439ecac3c9170342f"
    sha256 cellar: :any_skip_relocation, ventura:       "8b753f7e1ebc78e9104e3e35e96ce7aae18fa02cabe3f2d42cd85c60b7aece09"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "411ac990cce752ae9a7e6182c8410bcea94369f756daa026907194848c07e393"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e24a6c088935ac2fcf1028ea3bdf7ee4ee2672585a1a5c1105ad67aaf2819c91"
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
