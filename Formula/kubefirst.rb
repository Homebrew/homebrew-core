class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https://kubefirst.io/"
  url "https://github.com/kubefirst/kubefirst/archive/refs/tags/1.10.9.tar.gz"
  sha256 "f03b1aaa478813fd3f8d2e0258bf9792cceb85cec57f2676da5f9a46ae15a4b4"
  license "MIT"
  head "https://github.com/kubefirst/kubefirst.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cee514ea131439ec234abb62e4783ab2ef035e7aaa076068ef2d16219e627a96"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f625e32c554aaf951fa41110935023f7e1f3e772989fee7393ca80b04a2578e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd2fa1490f390cfac67c93070cdc14989af4a7b1597be4fbd38a309ca500b316"
    sha256 cellar: :any_skip_relocation, ventura:        "5da048a6466c8265c642c2cf008324dd8c7519d0c59664a0f9c8fc1c1a9609fb"
    sha256 cellar: :any_skip_relocation, monterey:       "bcd775e47457ca90ee2eab4366f9a2c0596deb5189f7f6fdae68d03da347bea6"
    sha256 cellar: :any_skip_relocation, big_sur:        "5d62a5375b2f4747a560e77db85bca1b69c9dc4b710a52a54371a4df46362c15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17164b7016291eda667f5777ca0bbcd3a8bc99c7eefb549e4a1c7e38161e5cae"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/kubefirst/kubefirst/configs.K1Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"kubefirst", "completion")
  end

  test do
    system bin/"kubefirst", "info"
    assert_match "createdby: installer", (testpath/".kubefirst").read
    assert_predicate testpath/"logs", :exist?

    output = <<~EOS
      +------------------+--------------------+
      | ADDON NAME       | INSTALLED?         |
      +------------------+--------------------+
      | Addons Available | Supported by       |
      +------------------+--------------------+
      | kusk             | kubeshop/kubefirst |
      +------------------+--------------------+
    EOS
    assert_match output, shell_output("#{bin}/kubefirst addon list")

    assert_match version.to_s, shell_output("#{bin}/kubefirst version")
  end
end
