class Grpcui < Formula
  desc "Interactive web UI for gRPC, along the lines of postman"
  homepage "https://github.com/fullstorydev/grpcui"
  url "https://github.com/fullstorydev/grpcui/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "43e127082396b1ea11f4687a6f69555579b34501538e7ca361c9db35e486139d"
  license "MIT"
  head "https://github.com/fullstorydev/grpcui.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf74d97098a29197ee6c9ae3c21a911c779478d507e931d8459b66f0d2737ff7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf74d97098a29197ee6c9ae3c21a911c779478d507e931d8459b66f0d2737ff7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf74d97098a29197ee6c9ae3c21a911c779478d507e931d8459b66f0d2737ff7"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ce138c823addafcf29598383b96e2f2faa293ecc096a73e49a2fc8fdba01233"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b398f493cd63ed826569391fd6fff8b0debaa000f847dbefce603d04e09957c"
    sha256 cellar: :any,                 x86_64_linux:  "44d6f84caed7dddad5cd4043924e4e6594ca219da1d55c4fe9b9ddc0dfcbf5a5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/grpcui"
  end

  test do
    host = "no.such.host.dev"
    output = shell_output("#{bin}/grpcui #{host}:999 2>&1", 1)
    assert_match(/Failed to dial target host "#{Regexp.escape(host)}:999":.*: no such host/, output)
  end
end
