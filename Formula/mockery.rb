class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/v2.9.4.tar.gz"
  sha256 "9c490eaa5dd509581e7c272d6af22b17c22b2915267e242ce927f17850ff4a59"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "92dc624d349f88d2029f28e513808bd6b8f24f871e55c0d10b9975d2ee170cc6"
    sha256 cellar: :any_skip_relocation, big_sur:       "6ebf577eef38b9affb0ec0be68cf4e9c0bffcbbd23c3fc1d46ca2bd987c39b11"
    sha256 cellar: :any_skip_relocation, catalina:      "1c0c6e14894c388c3985bb361414039c1b3a6e74ad0fe3710b33f245835197b0"
    sha256 cellar: :any_skip_relocation, mojave:        "9643482a4f0658f8c9029ec6f41f103bfb2fceb7e9b3dfb7d2acf624462cc22c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "911a6787aa90e51282ff9ab95b3d6a1f1cd0ea673adb0f05236b3ee554606519"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/vektra/mockery/v2/pkg/config.SemVer=#{version}")
  end

  test do
    output = shell_output("#{bin}/mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=#{version}", output

    output = shell_output("#{bin}/mockery --all --dry-run 2>&1")
    assert_match "INF Walking dry-run=true version=#{version}", output
  end
end
