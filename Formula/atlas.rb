class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  url "https://github.com/ariga/atlas/archive/v0.7.2.tar.gz"
  sha256 "29c866f7b29dad1f4ae2341bd7ba0e85f229c16dec11de8a70affc404ade1bef"
  license "Apache-2.0"
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b28c7b24606b892f89e1821649a9499fe13885624e0742459229b34e73c2762e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d8083bd15ee880080b0a0b81d42a4a4c3ff02f3d1c52076d59974a7a70ddf29c"
    sha256 cellar: :any_skip_relocation, monterey:       "bdabdacef8692cd364e2d0c490f882d0f622cf26bf6fc2d38c98e818abadb9a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "ef7267021c9dd2340c029aa9241f6ab12dd4fd975e4c6fcd0e720fc09c28744e"
    sha256 cellar: :any_skip_relocation, catalina:       "02d6e745d8dc2b2f8bfa27249875d272a6877a4b2786f6a168cc89fefecaab80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3717eab7518dfad965422c5a48c6ab5819814f2653798ff0cceec6ea83fc8ae7"
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
