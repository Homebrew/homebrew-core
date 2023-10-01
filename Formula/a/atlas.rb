class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  # Upstream may not mark patch releases as latest on GitHub; it is fine to ship them.
  # See https://github.com/ariga/atlas/issues/1090#issuecomment-1225258408
  url "https://github.com/ariga/atlas/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "28a19054c724e65e0907c56f571f6cca2c26bbd69a863d249381a91f0f8d063c"
  license "Apache-2.0"
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e55b2733a4985042a662115108ef013116794837cecb2d040ed39ccc9322b28d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab39b989bd54d3bc4fd01b4e18cfcadd4796d743a7e5123d0a22927b516df167"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "416a157791feba231e923586481cbbb9041f83d94d0e7742caed50bc483c64c0"
    sha256 cellar: :any_skip_relocation, ventura:        "553f0100d6b3ee30dde9dce4d9aab8958462a4ff673caf9e197b17a492c57e49"
    sha256 cellar: :any_skip_relocation, monterey:       "992a2a5b7a63dc0d70468b0e02d9470b42ec7d5b7221bb5aaf5d22daf6cc1318"
    sha256 cellar: :any_skip_relocation, big_sur:        "c781ceb20e24cad0288e0cce3b4a33161e25ec5608099492aee4c84e057cd2a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f993f059c9ba811fef6c37fb8f63bb30a906cab65b6e0097644ea541550cf57"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X ariga.io/atlas/cmd/atlas/internal/cmdapi.version=v#{version}
    ]
    cd "./cmd/atlas" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    generate_completions_from_executable(bin/"atlas", "completion")
  end

  test do
    assert_match "Error: mysql: query system variables:",
      shell_output("#{bin}/atlas schema inspect -u \"mysql://user:pass@localhost:3306/dbname\" 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/atlas version")
  end
end
