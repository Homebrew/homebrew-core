class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/v2.10.1.tar.gz"
  sha256 "badcbf9b4701cf18be66a4a243eb9b9a442c98035fd0ae1e35f06eac4a448e89"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24ee8afd3bb40008043a858a6af3f8991f4f3368b065d7bc39507bce507412a0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c0bc088d067640fab78e3047c52f60cae2fc47e4756c083fcd0ab9e4dc41023c"
    sha256 cellar: :any_skip_relocation, monterey:       "b0203b946d37aaf80a0ffc7fbc3076bbf98246611a487a9427e486f0e7f63b6f"
    sha256 cellar: :any_skip_relocation, big_sur:        "f83a6cc31d6ba6318b4a47bc25a97ad9ac37db408ce28c4330818c9424f09dd8"
    sha256 cellar: :any_skip_relocation, catalina:       "3e8b29805a942aaec44b9fd54644314489f8decf436794f370178decdd2c0b63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "761e9d9c086138291eda6a4f7bb717512366a75931b44d2073fdf8b2c454f707"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/vektra/mockery/v2/pkg/config.SemVer=v#{version}")
  end

  test do
    output = shell_output("#{bin}/mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=v#{version}", output

    output = shell_output("#{bin}/mockery --all --dry-run 2>&1")
    assert_match "INF Walking dry-run=true version=v#{version}", output
  end
end
