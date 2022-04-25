class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/v2.12.1.tar.gz"
  sha256 "62b2652fb245372815cdce61511dcb91d83ab6944774ef8e90bab7b30b26660c"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45bf330ab45838621b3fb860fb85af41c3cf4b327937e2c34aa0d079067d3a34"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "995b3b8d1d347d29652e9b7e96f7aea1893a0cf9c559467ee5801021d472361c"
    sha256 cellar: :any_skip_relocation, monterey:       "a4c5ef39d6cb69f7bbbc4ffcc1e45cfa1a9b3778905b188bf7c6c09cd32fa03a"
    sha256 cellar: :any_skip_relocation, big_sur:        "c356f1e08d60b0617e84d0bd81068167eafce9fad8005f9c2cb477f5312d3e45"
    sha256 cellar: :any_skip_relocation, catalina:       "7e33dd347882a740cc24b881961bdeb36fbe8272e7c8c1c6a0ac63965b968426"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fb1b4b2c558517e28db4a412f71c47502b59f816168dd92ceb9abbae5a69b5a"
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
