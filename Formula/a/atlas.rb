class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  # Upstream may not mark patch releases as latest on GitHub; it is fine to ship them.
  # See https://github.com/ariga/atlas/issues/1090#issuecomment-1225258408
  url "https://github.com/ariga/atlas/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "aa01d568af8c46cfc4467d3b09320586d51267f41460f6c31f5a1519b5e2087f"
  license "Apache-2.0"
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c447b525d7fd5beba2fa5da2b0aaf3ae2c19eac8dda06d9b062bbd88b14bb93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "935034c10dd28f3a87cc0d5973bcd488df713b0500e05051e9b1884b8b2ca54f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "adf0f6ce533a8debbe454e210a20e2c42311d6ad77aaa85f874626eceeda4c21"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d4da3dd70cbf787728dd4ea06c8cd155eee07222fb7c6f4eaa50880c9d4d553"
    sha256 cellar: :any_skip_relocation, ventura:       "b654ce40a5200e06693d02e4d7b74c5cc9224c15733a45f9fab899a4e45a8136"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c188954a4259cc8e25804dc0b91989e1e28796b04ae74f2460e862a2d310859f"
  end

  depends_on "go" => :build

  conflicts_with "mongodb-atlas-cli", "nim", because: "both install `atlas` executable"

  def install
    ldflags = %W[
      -s -w
      -X ariga.io/atlas/cmd/atlas/internal/cmdapi.version=v#{version}
    ]
    cd "./cmd/atlas" do
      system "go", "build", *std_go_args(ldflags:)
    end

    generate_completions_from_executable(bin/"atlas", "completion")
  end

  test do
    assert_match "Error: mysql: query system variables:",
      shell_output("#{bin}/atlas schema inspect -u \"mysql://user:pass@localhost:3306/dbname\" 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/atlas version")
  end
end
