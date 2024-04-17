class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/refs/tags/v2.42.2.tar.gz"
  sha256 "c4ceabcf90a331514caa5288a2a6c3d93e3237be7414d18ea7e14f0e2a961a37"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0e97944f9dd2bdd8a25fc5aeeb67f1f834c6c443503f61079c276e608a2463f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0097335d703ce681bcace280ac69071b3ee895a3ec788a795dbc5be43a0c256"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78ff03d6faaa222b130faaf34577cb6f6fc08acb9ae47dbd1bdcfb7b16ba00e5"
    sha256 cellar: :any_skip_relocation, sonoma:         "2fc2d0c8f0114e257026b23bdd1b9e031c2ac69a182415bf207d94f8163d7d0b"
    sha256 cellar: :any_skip_relocation, ventura:        "8faa64a3a3a82e57d40b6a23daf198ab35fe574714b75b7f78798b535a918849"
    sha256 cellar: :any_skip_relocation, monterey:       "c24b4b1445b55f15ea374ee03a8241b12f548001be5a1c6c6dca912be2024d6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2f70f536c64854d509b15a0d60798f13bbe160f75fce5e3ee36525e8dbcd255"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/vektra/mockery/v2/pkg/logging.SemVer=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"mockery", "completion")
  end

  test do
    output = shell_output("#{bin}/mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=v#{version}", output

    output = shell_output("#{bin}/mockery --all --dry-run 2>&1")
    assert_match "INF Starting mockery dry-run=true version=v#{version}", output
  end
end
