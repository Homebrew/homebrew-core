class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/2.9.1.tar.gz"
  sha256 "f26b52d1d220ccb4826ed69ccb52e80df3307d4a33532a2de240d4cb03912418"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc287634b987d09dccc5c2606fb9e8ee34162d66c2fcf7c84da97bcec9607379"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f00d6c91b032189e6406962e8fda0e10f141a3d0c785c3d4459bef06e1f5c84"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f87d661aa7b1d3adb18f2299df3d5bf0439388e791661bd3b6c1cf84ad0e3f1a"
    sha256 cellar: :any_skip_relocation, ventura:        "d5274cd69ebcd03d7ec136ed8b28c962b9192ab2b6c576e73ebab019d3e2829e"
    sha256 cellar: :any_skip_relocation, monterey:       "2c66c729b61f44c485f4f583201915c9f49ebf38999fd8a2301ed5fe877a0bff"
    sha256 cellar: :any_skip_relocation, big_sur:        "13650533ca0aeec61e0434dce0c6ae14d041f7f5a80bbbe767d586c25ed9f3ea"
    sha256 cellar: :any_skip_relocation, catalina:       "59e4d16398874f0c3dc4b32bca650abde39a1a2f57da52ab138f0d8980b0851a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bcd8b0b8ec255fd836306b73d96825f694165bd710816e9f6ebb28dbe55a00b4"
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
