class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  url "https://github.com/ariga/atlas/archive/v0.8.0.tar.gz"
  sha256 "b9d54b6e0ef616742ef8cc702d3e0f624272a0caaf9751c0719c994e5d534e2b"
  license "Apache-2.0"
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f085e2d280318403244b83c6698567cc7cefdbe5b9077b7c8de13737f1e15500"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "31609e49e7664094a58048425931cbffc788dbce899deaa75cf02a3ee9a6a242"
    sha256 cellar: :any_skip_relocation, monterey:       "478a8ce19ca21196655a53d6917f5a6a74664a549f93aee0be563544e863b078"
    sha256 cellar: :any_skip_relocation, big_sur:        "53f8d33e9e09b217a76ec4f2f39fbaf1bcc8a0ff771a8195421d12cbbcae9396"
    sha256 cellar: :any_skip_relocation, catalina:       "0f28a9ecc57d48f207bfc8d01073a7c74ad18b8256b73045a28595e77868e79d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6450fd51310b39ff6a59b3a4945b2da8170e1521f30398d34b9b5efd07342aaf"
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
