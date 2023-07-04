class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https://kubefirst.io/"
  url "https://github.com/kubefirst/kubefirst/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "a18165a4542e2de4ea10d6f72cd17a65424748166e9f727dd7ac121cf291065c"
  license "MIT"
  head "https://github.com/kubefirst/kubefirst.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25c9d6af475199f4c4b48be0d6b6487151cc876dd207659c22669114b01e1a84"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d795cde2490296cd97fb679b22b5d22a95749ff2f31ab20574fd47b575fe319e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4272c08e6d5d0381cf367a6c1e77af65bcc82eca5de5d4e7c54fd07413da0d88"
    sha256 cellar: :any_skip_relocation, ventura:        "42948c26eb1bf96b5101b2a8946b958b5be29e22e62839eff2b0f48d696d7fbe"
    sha256 cellar: :any_skip_relocation, monterey:       "3c766d26f654a90c7b0793dbd9255f41b603589ae3b03f223c2a8339dfee34e0"
    sha256 cellar: :any_skip_relocation, big_sur:        "1ce1a206e3aa5114bea2399159bb895625a2802d824b2dfc15e6d49be75f4edb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc5f0c11a72897bb1496a5a0ef1e2df300a15fa64fa4ff08d70bce5e6ad2969a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/kubefirst/runtime/configs.K1Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"kubefirst", "completion")
  end

  test do
    system bin/"kubefirst", "info"
    assert_match "k1-paths:", (testpath/".kubefirst").read
    assert_predicate testpath/".k1/logs", :exist?

    assert_match "v#{version}", shell_output("#{bin}/kubefirst version")
  end
end
