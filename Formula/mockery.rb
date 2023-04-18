class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/refs/tags/v2.25.1.tar.gz"
  sha256 "8f73afeb3fbca3f6eff3a0150f56e49e4e425c618c3e8cda4f1ba08c50b47041"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "45867899e6fba01d8e967ce2d133b13edc1f3659e6e31368f3292ae3a888b669"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5815c39d402f874b58eb08d1b450cd9b73c00715c5dd9c3033cfbb75be339f71"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "77775489a5fd208b10569cabc38536579219497fbfc7599faf1b5a4b034b0ccf"
    sha256 cellar: :any_skip_relocation, ventura:        "a9ca13eaf136860e25a77f357c8369ba687d32b54e65041a613f006aee92b123"
    sha256 cellar: :any_skip_relocation, monterey:       "e7aa6341267147cd50c2d0e4e8c7225d4eb47ce9e76b190527b8bbcdd642368c"
    sha256 cellar: :any_skip_relocation, big_sur:        "86051f9bae36e9f76e5cfbd9f261e8b4b027e74a300e7e3f1ca6363fae3814da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dcbed432b9d8353f31dcb37bd4a9464ac9865d564b353b180ac21adcd98e595c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/vektra/mockery/v2/pkg/logging.SemVer=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"mockery", "completion")
  end

  test do
    output = shell_output("#{bin}/mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=v#{version}", output

    output = shell_output("#{bin}/mockery --all --dry-run 2>&1")
    assert_match "INF Starting mockery dry-run=true version=v#{version}", output
  end
end
