class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/v2.20.0.tar.gz"
  sha256 "4282a537933cfc41001b0b13ff3949600cf3a66e3937c7dedb093fa0c577bd8d"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e42bfc719233d0ada272bfac4cb72b66ecef3116461840b7769c648404c8479f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f71621152131b0ba385fdcb6beb53e5f62515a028e9e7abaccc7f81a37b4a70"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5d08b5f0428a33e324e97650d6a27f2f317583ea9360096445235e7d5f1f0e3c"
    sha256 cellar: :any_skip_relocation, ventura:        "cab5ae8a873583cd56051a5c545f1579899782c2c5ca2f20e73804963bde8ff1"
    sha256 cellar: :any_skip_relocation, monterey:       "c53712f7bc6af166f444fec53265c18bdc4336fd0f8038058a325e7ff65a5aaa"
    sha256 cellar: :any_skip_relocation, big_sur:        "1bb3e6540bbc3c0c7be3519c071e8d22fd8cbb3a1b31b77f2b564e860fbb2214"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3faa896a1f8d73d1a2b8c9829d434d8f17d4bfe7a2f513603d4708a3da70f8a2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/vektra/mockery/v2/pkg/config.SemVer=v#{version}")

    generate_completions_from_executable(bin/"mockery", "completion")
  end

  test do
    output = shell_output("#{bin}/mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=v#{version}", output

    output = shell_output("#{bin}/mockery --all --dry-run 2>&1")
    assert_match "INF Walking dry-run=true version=v#{version}", output
  end
end
