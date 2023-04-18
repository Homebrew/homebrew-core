class Kubecm < Formula
  desc "KubeConfig Manager"
  homepage "https://kubecm.cloud"
  url "https://github.com/sunny0826/kubecm/archive/v0.22.1.tar.gz"
  sha256 "ebcb950120ac61114748f47f9febabce74d70c86171837023b2f63e71e4c5ccf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "557f2261da5a7109b982e6e05dd2c581fa6c54f50ef01afe010b927324995093"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "557f2261da5a7109b982e6e05dd2c581fa6c54f50ef01afe010b927324995093"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "557f2261da5a7109b982e6e05dd2c581fa6c54f50ef01afe010b927324995093"
    sha256 cellar: :any_skip_relocation, ventura:        "37db7eba40c1fd6a127fa1deca3cc6038ab0e88e89ec4b73d689cc2c63c0fd19"
    sha256 cellar: :any_skip_relocation, monterey:       "37db7eba40c1fd6a127fa1deca3cc6038ab0e88e89ec4b73d689cc2c63c0fd19"
    sha256 cellar: :any_skip_relocation, big_sur:        "37db7eba40c1fd6a127fa1deca3cc6038ab0e88e89ec4b73d689cc2c63c0fd19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a242c449dcf1d839137991440355b29d4334109ce0c562973339a99e6264e4ec"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/sunny0826/kubecm/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"kubecm", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubecm version")
    # Should error out as switch context need kubeconfig
    assert_match "Error: open", shell_output("#{bin}/kubecm switch 2>&1", 1)
  end
end
