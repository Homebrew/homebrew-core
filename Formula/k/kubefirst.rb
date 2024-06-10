class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https://kubefirst.io/"
  url "https://github.com/kubefirst/kubefirst/archive/refs/tags/v2.4.9.tar.gz"
  sha256 "edcdac000cd662960164a12746165a4f6c1c0a2bde8ddcb534363929384317d8"
  license "MIT"
  head "https://github.com/kubefirst/kubefirst.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released, so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "889b46f158c743eeb560d61abf762fb5e688f6686d8428efca8a41b7a23dc17c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0d24aa280a70bf61f4c92776828f4abeda915adaab855cf48d50ee12cc4bd9fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5e6a68d1924f2a3e8e58e7dd285178ddfc89cc25903225c3a481d18c308f1b7"
    sha256 cellar: :any_skip_relocation, sonoma:         "fcd351207d76c54da3bf452dff7aa2e32ac211dd58cf34420d8d657558c9811e"
    sha256 cellar: :any_skip_relocation, ventura:        "815559fe99e99d92f2ad12e3ef5d8e4f4bd3b827cb9dd1380133160523305f2f"
    sha256 cellar: :any_skip_relocation, monterey:       "e221bb61ac7222551b562ccb7523a0ddacb3cd2d88e8a8178f88b06a351037e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a367698f970d81406b1a481afc78d9440b10af06a4c4b3eaaaf80497d8cf3aa3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/kubefirst/runtime/configs.K1Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    system bin/"kubefirst", "info"
    assert_match "k1-paths:", (testpath/".kubefirst").read
    assert_predicate testpath/".k1/logs", :exist?

    output = shell_output("#{bin}/kubefirst version")
    expected = if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      ""
    else
      version.to_s
    end
    assert_match expected, output
  end
end
