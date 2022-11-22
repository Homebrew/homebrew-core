class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.180.tar.gz"
  sha256 "2ae0a2964388ff3711892e419e17442c7fe8e3e3da46717e8f1e682c0f9e7054"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "72157370d33463bf3f7c320a874b913acbf5896c27bc2dce7634c1b36b6d97e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb7e2c039e438f9bc283404389ca67fdba3fdc7571cd764be3dd4e0158d5da16"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dbcdd8199d23981a034276a7ad09f8c11915fc0ec1dcd393db24af2b2fde04bb"
    sha256 cellar: :any_skip_relocation, monterey:       "2b72d7318ed8ff9eca9a99e78a1fd04f1260aa0e3e2e677e29a01c669d87f390"
    sha256 cellar: :any_skip_relocation, big_sur:        "7ba5fdca0925ba09fd09a371e52ca079f5b39201c69871db1553ff17307d4714"
    sha256 cellar: :any_skip_relocation, catalina:       "4dd2f0e2fd339275cc4e4f72f303a215d94c5b37c816ee5ebe682cb9d2520ac1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "262dd74b3ab91590d8842d23d1e7a47edfe2462177203ba7795db4ed4d8b0009"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"brev", "completion")
  end

  test do
    system bin/"brev", "healthcheck"
  end
end
