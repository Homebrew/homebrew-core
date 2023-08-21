class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  url "https://github.com/ariga/atlas/archive/v0.13.1.tar.gz"
  sha256 "fcdb846dc9dea0af26da638557cf47de1d027c30fb75cf82692e2f3f604f77e9"
  license "Apache-2.0"
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8aac14483751b63373c8c8b1f35f4d45d102837d52e2c4888c266bbee73a7319"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a7f249b8883fb268664955bb6a4f2689f8e6c425bd7fbe5fcf835e4c6dc3840"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "95f410cd9a45e210f5a02395c6eb77b3238a0af9e89cfcd4b4921c32a9ba8b96"
    sha256 cellar: :any_skip_relocation, ventura:        "91563044591fd75d0442625ef9230615856f287ec6905e5cfa8c0d55b03dc240"
    sha256 cellar: :any_skip_relocation, monterey:       "8bd921c5188d714ef341e09541796dcbda715be55b7a18e8ade5149871f14800"
    sha256 cellar: :any_skip_relocation, big_sur:        "380fc70c187d43f5477546f089d9b3f2272d238d14c63a0a0e73b88f18c1f05a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28e66b7905e9eae2d9e7c0ebb946b134765a634050b45295519053dbabc2d467"
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
