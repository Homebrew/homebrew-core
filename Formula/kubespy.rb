class Kubespy < Formula
  desc "Tools for observing Kubernetes resources in realtime"
  homepage "https://github.com/pulumi/kubespy"
  url "https://github.com/pulumi/kubespy/archive/v0.6.1.tar.gz"
  sha256 "431f4b54ac3cc890cd3ddd0c83d4e8ae8a36cf036dfb6950b76577a68b6d2157"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6cc273c106fc5bfcd196266862c0d6d2b7c41dddc193a6af3f04b4a57eafc3da"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4b636df3c960c6070f39ed27d5150f49b138ae270577fcc3281b6bd730463c61"
    sha256 cellar: :any_skip_relocation, monterey:       "32f272603fb848cca0a022a6e9eaadea61369cc04de7726c46cca9adc9a98d3c"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e2501ef6eb8341e9cc420da16061c3527aa062b5e7150cfa8fd16249eb168ea"
    sha256 cellar: :any_skip_relocation, catalina:       "277ef57273c272caf8a8a3a7028d850daf6d3499b23ebbcd53a6b5e535c3d205"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd7e54744796814089311a48ad6210bf82c65236058558f4c93f4896fe63c049"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X github.com/pulumi/kubespy/version.Version=#{version}")

    generate_completions_from_executable(bin/"kubespy", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubespy version")

    assert_match "invalid configuration: no configuration has been provided",
                 shell_output("#{bin}/kubespy status v1 Pod nginx 2>&1", 1)
  end
end
