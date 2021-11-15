class Grpcui < Formula
  desc "Interactive web UI for gRPC, along the lines of postman"
  homepage "https://github.com/fullstorydev/grpcui"
  url "https://github.com/fullstorydev/grpcui/archive/v1.2.0.tar.gz"
  sha256 "20d109dc9f91ad2ca8e185ac60e9d36ece56282dd65ee9cf735322471ca0fe40"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fce7993640d204eb23eb9ff116a6424087c21a2ce993c2ea30f275a0f3f5d76a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "27ae7af8edc3278d10d292346dac4e506b5327be13798e61043b6abed02bf180"
    sha256 cellar: :any_skip_relocation, monterey:       "8a3914efcbf4dd30ec8f691eae141fe47473806b2a8aeb5a63c203be87fe128c"
    sha256 cellar: :any_skip_relocation, big_sur:        "71a0cdc312f8bfdb46c7b7e3bc79679df597221a83cda19a758510d48f913a44"
    sha256 cellar: :any_skip_relocation, catalina:       "61bf96a0bf8953c2e44f56152dfb1206d05cdeada7b4c6673ada05a0eafe948a"
    sha256 cellar: :any_skip_relocation, mojave:         "9b1eb0f2f5331431d94108aa040a85dfa4aa573d2742d4ea70caf31740185a16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ff5bb71c7f93d0cf773c33a110c91562e73ecc0aa5ac231e512106b99211ed5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-X main.version=#{version}", "./cmd/grpcui"
  end

  test do
    host = "no.such.host.dev"
    output = shell_output("#{bin}/grpcui #{host}:999 2>&1", 1)
    assert_match(/Failed to dial target host "#{Regexp.escape(host)}:999":.*: no such host/, output)
  end
end
