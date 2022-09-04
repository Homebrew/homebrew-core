class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.8.41",
      revision: "01c3ce4c1452574bed83123c1a8e79bd0c81f083"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f4a689064a5580410280bf5a04b62bd228db47f607733c44457c070a4b86df4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e45e7dd8800d8fff151e501020632b2dff30f32cef7cef83b06e56b67127d672"
    sha256 cellar: :any_skip_relocation, monterey:       "673828d8ec45eee1029626793d5b38268842019e182c7ab878b0a5998a98f014"
    sha256 cellar: :any_skip_relocation, big_sur:        "701309d8439ff74f41a63451e79fd801e065cd9b0c5e67e92d4051f59ea6488e"
    sha256 cellar: :any_skip_relocation, catalina:       "a482b53fd426c16051c069cdd3f5539744bf5727efe9121138619def90fac2bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5a5b504c81a0800023c97de6c86382de48803808a0f7910cc023dfd00f82caa"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/alexellis/arkade/cmd.Version=#{version}
      -X github.com/alexellis/arkade/cmd.GitCommit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    bin.install_symlink "arkade" => "ark"

    generate_completions_from_executable(bin/"arkade", "completion")
    # make zsh completion also work for `ark` symlink
    inreplace zsh_completion/"_arkade", "#compdef arkade", "#compdef arkade ark=arkade"
  end

  test do
    assert_match "Version: #{version}", shell_output(bin/"arkade version")
    assert_match "Info for app: openfaas", shell_output(bin/"arkade info openfaas")
  end
end
