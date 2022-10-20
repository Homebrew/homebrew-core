class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/v2.14.0.tar.gz"
  sha256 "1a87d16b264d21c65eb7c18b0a55a206798017bb48672ef8bc403b420dc0d5e8"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0cc45148a85352f94baaf806c0fc3c930fcf657c3b39793d263c5518fcdb8679"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "75c1fc12f85faaafdca9835a2430c180b6727aa8b6af51ac27468d39e7edafd2"
    sha256 cellar: :any_skip_relocation, monterey:       "e1332a2baf65967832c436b122877b7f7b2cacbc433aa7a258ac127387bebef8"
    sha256 cellar: :any_skip_relocation, big_sur:        "b71d2051a8315f6f40576e41ce6c94cbf2fcb22bfa066990dbba961bcb446d36"
    sha256 cellar: :any_skip_relocation, catalina:       "9608ee70ae6fccb0c4a121401bbcbf11c27b55a6bb1cb9185055efafa544187f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba19c5c3d33a405563365b3504bb2d66b72fba2a8e0f9489f73c73d690b2d8d4"
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
