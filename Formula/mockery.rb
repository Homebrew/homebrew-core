class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/v2.9.4.tar.gz"
  sha256 "9c490eaa5dd509581e7c272d6af22b17c22b2915267e242ce927f17850ff4a59"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/vektra/mockery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d1d259c644ae55bc2577baf1d664756db4e54171c030255223f436d3e4a2fbf2"
    sha256 cellar: :any_skip_relocation, big_sur:       "01ff23f0504e67ac8234d99feccb7c544f98de940df1cb22f5954a91ac80bec3"
    sha256 cellar: :any_skip_relocation, catalina:      "5add75eeed24adb0d0d9cfb7e1078eed991349e455ed9e8b3c8c38dba38b5a7c"
    sha256 cellar: :any_skip_relocation, mojave:        "dafde0009ff38d7a88c3a4a1d39b53b712940cd6cbfcdf5efe6a3db29b8aba10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae4a6c1b38c22c1c1e5b4d81c035e602443d1cb96574eff07cd26eca423539fe"
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
