class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  url "https://github.com/ariga/atlas/archive/v0.8.2.tar.gz"
  sha256 "964415d53665a2c7762f2abedade79df434995793a2e3233bb04c6cb8b4c49da"
  license "Apache-2.0"
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68e2bfd057eb5962b2df5b36c02a7851d025183f993032c7698353311023c150"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4f5d4d9e384196cecfb2e8c2f829e30af23ef161c373647f59221be99653e98"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f30c27b1ffd18443bfc0d4256eb08e8b97015a80544c7112b4cc42c81872aef8"
    sha256 cellar: :any_skip_relocation, ventura:        "0088d1c79c61001d4becf3b3f0a496146aae3a873edc9844dd71e35b73f5d85e"
    sha256 cellar: :any_skip_relocation, monterey:       "0ee575b1dcbd4b498d13861e693b5878a0ad770e5aa1cb9e2cd2fa9ee5556924"
    sha256 cellar: :any_skip_relocation, big_sur:        "07a6973bdc8b1c57c56e5a9ea150fc0ba383f0e8637c7f326f490c765de3e46d"
    sha256 cellar: :any_skip_relocation, catalina:       "ea7e8a75fccd44f76a351a6fccd25fae7ed31b85ba90cf1d23f8d8ea01cbd29f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5299b78e9fc8c61545d8e9ef07081dea5de6ff0dc8a34be4695cc7e57e014ef5"
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
