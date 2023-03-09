class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/refs/tags/v2.21.6.tar.gz"
  sha256 "e7cdb393f104efda74da9e94d02461d4afcc22b330ad5d557a8e97ab3ab14438"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bec8b0b02a99b14bcae1a556a2c77f1ce0acf0974c4246151a5dc686e90262fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6223617a8f8d638db1a14466975286a74d6d6c751bc092c47553d4a15a93bf5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "04fd59d3de877936b130099073045a042fb2e49901b1327efb20652ed2de4950"
    sha256 cellar: :any_skip_relocation, ventura:        "6431b60e83d1d5a05ba8d1d00557ed48afdb8f6174fc21645be1b1db12be551b"
    sha256 cellar: :any_skip_relocation, monterey:       "c1d32bd68512d09a0c58146e80521c20ea8f884d5f89d535d3e30a447cc9dada"
    sha256 cellar: :any_skip_relocation, big_sur:        "f606e26eff06783e1efc56287f813c93bd8de5b0433c2f843b553b7b57d1cb0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3886bea4ea2d48e7af7fcec7bcb3bbba09f6b433b78ff81c9794e59bb2622c12"
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
