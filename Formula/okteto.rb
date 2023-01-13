class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/2.11.1.tar.gz"
  sha256 "7753ab2b297494994030a08cd498f18c6d0757e11a502fa70458bf0b1e5bd932"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f3a5647935198d6587904aaaa49a016f2e8cb992c7690178e12c0d35541d64e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "836897af3aaadfd22307f0991b093d85630a8af123a228bd6a0a274ab070271b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f6485f9ccb46d9c6b4ee834c920d534ceaa64ac544f635975dd80ead33244360"
    sha256 cellar: :any_skip_relocation, ventura:        "9b5a9b9c8f5dd9651d39ff5999801a7ca16b66f1dbd349edae28978587573753"
    sha256 cellar: :any_skip_relocation, monterey:       "e06a88681b11f1daa2ec2c9586eae945b903031f754e86ad2e24cbeb204412dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "91bace271393284aecb26fbcbcd541809e24eef09e1e49c02a7f6b51aba07567"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7f6434ca75bbd2725e4c0c4df7c9046945ba20348490d6b9e5ddb2f0cc70824"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags

    generate_completions_from_executable(bin/"okteto", "completion")
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    assert_match "Please run 'okteto context' to select one context",
      shell_output(bin/"okteto init --context test 2>&1", 1)

    assert_match "Your context is not set",
      shell_output(bin/"okteto context list 2>&1", 1)
  end
end
