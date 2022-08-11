class Kubecm < Formula
  desc "KubeConfig Manager"
  homepage "https://kubecm.cloud"
  url "https://github.com/sunny0826/kubecm/archive/v0.18.0.tar.gz"
  sha256 "b9a5ac1d3fe144caf65783320389d356fc9435c65f3c5b1b2a729d1ab908212d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af1f5f67edc0a059a8fa1b8f1aa30ebae2eeb4c9a54957f2a72421b90adc42d3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dcce16599d6455fec5b96388c11909e0736d9ca46ab4dbd6666ce9808ad8f22c"
    sha256 cellar: :any_skip_relocation, monterey:       "c4d68d960b6f43e7cce29f4dea1a8379e0fd5afa2e280bc1b86326c3c258c07c"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad035dc2c1300926f6698fc2af16e92e2cd6d8fd6ef88b111f0bccb3f49af8de"
    sha256 cellar: :any_skip_relocation, catalina:       "f9bfbaa4309d5b403f94ce362950eae9a1f2a553ab701fb86d433b830eeee1d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c36c0defed497ad2a602522bd37664a4574c3e143415b862a3dcb9ffffe6078a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/sunny0826/kubecm/cmd.kubecmVersion=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"kubecm", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubecm version")
    # Should error out as switch context need kubeconfig
    assert_match "Error: open", shell_output("#{bin}/kubecm switch 2>&1", 1)
  end
end
