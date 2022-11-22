class Kubekey < Formula
  desc "Installer for Kubernetes and / or KubeSphere, and related cloud-native add-ons"
  homepage "https://kubesphere.io"
  url "https://github.com/kubesphere/kubekey.git",
      tag:      "v3.0.2",
      revision: "1c395d22e75528d0a7d07c40e1af4830de265a23"
  license "Apache-2.0"
  head "https://github.com/kubesphere/kubekey.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e4ee47dc3ae1fb823d3f3d4013d4a61e6680df151f60f4f36b50943dfa39c7df"
    sha256 cellar: :any,                 arm64_monterey: "82959ff3075da363b27097344e851be75cc0ca40ba6f04b4ac7c04164f022552"
    sha256 cellar: :any,                 arm64_big_sur:  "0f94161e19905574b39cad194198ef09faf681ce5e664708e061640c4034a54c"
    sha256 cellar: :any,                 monterey:       "e10f25f3abe691e0676029b9b1e21f41544d6d1c08c493f9305e12bddd8dd4df"
    sha256 cellar: :any,                 big_sur:        "b095be057f1720459fdd23447ede29d6ca9dab857301b0da8699e9e12bc48159"
    sha256 cellar: :any,                 catalina:       "260f96d95c099e33a90ec6d5064bf9962b62cd5b5ac6568d4cedd23c775a739a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5999c1b6d976773da1184e3a572969e18fa69da6426f8155fb5a56686b0ba952"
  end

  depends_on "go" => :build
  depends_on "gpgme"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "btrfs-progs"
    depends_on "device-mapper"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/kubesphere/kubekey/version.gitMajor=#{version.major}
      -X github.com/kubesphere/kubekey/version.gitMinor=#{version.minor}
      -X github.com/kubesphere/kubekey/version.gitVersion=v#{version}
      -X github.com/kubesphere/kubekey/version.gitCommit=#{Utils.git_head}
      -X github.com/kubesphere/kubekey/version.gitTreeState=clean
      -X github.com/kubesphere/kubekey/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"kk"), "./cmd/kk"

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
