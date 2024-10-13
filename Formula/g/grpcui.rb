class Grpcui < Formula
  desc "Interactive web UI for gRPC, along the lines of postman"
  homepage "https://github.com/fullstorydev/grpcui"
  url "https://github.com/fullstorydev/grpcui/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "af7adbdfbf26d297056afdc95e5f9eed390a3c668c15a358fb135fc8b3188ac6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8218f707ed3b76afbbb444c2470c68a816a23da38ad2c5cfe338f27cff6a580a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "409cbd513224c978af314d09819f9b5127d210f5a183f30ecc75904c9d95527b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cec2bb7927963fdf92deb9a40696594a3a30089ef6face9ca74adf3941cbde52"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b629edca9f7ce2e5bb9e0945e52f801dd5ebed5a02254933f067ebb6348a50c"
    sha256 cellar: :any_skip_relocation, sonoma:         "10c668cb2f977a231190ec9fd012caa1aa589ceb67265b2b3ffe9a8555f44497"
    sha256 cellar: :any_skip_relocation, ventura:        "82608d661c1e52d77e890627953e3557da7058871d9aa95632ac8c78f09916b9"
    sha256 cellar: :any_skip_relocation, monterey:       "3b6cd41a010cf893c281371cf5a6f22ad63cdd278b813d3d7b2c76feb01a5907"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2246a8ee7dceaaf95ec491588b4703cd79d051ef923334a7f17b27aca4982b88"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/grpcui"
  end

  test do
    host = "no.such.host.dev"
    output = shell_output("#{bin}/grpcui #{host}:999 2>&1", 1)
    assert_match(/Failed to dial target host "#{Regexp.escape(host)}:999":.*: no such host/, output)
  end
end
