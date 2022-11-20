class Grpcui < Formula
  desc "Interactive web UI for gRPC, along the lines of postman"
  homepage "https://github.com/fullstorydev/grpcui"
  url "https://github.com/fullstorydev/grpcui/archive/v1.3.1.tar.gz"
  sha256 "01cfa0bbaf9cfdaa61ae0341c83cde3372854133d62cb9b91c3a111eaa145815"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d697d0e919d9fa8a1565e430253683817a84f55528e73649c3e2445261ed0ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba273507be5cfd956eca6209502841765d567470fa9fb345f7ea798edd0e813a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "85fe72471da84abadc9c0856126401492c0b5adcf3ee5e130d8dc1d446ded77c"
    sha256 cellar: :any_skip_relocation, ventura:        "be11c0927b3d367f457dac919cf407cec2db564c47ba176e28225e5d9c3b77fe"
    sha256 cellar: :any_skip_relocation, monterey:       "6457e94f362363820b001de52fc7aaed951bc19025bb770492fac0ca781399a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "b8f838101ee7c939423536200c67c6d4b26a480cb812839d802cc93bd4224674"
    sha256 cellar: :any_skip_relocation, catalina:       "19ebbde82058c600bb9fb9467643c7fd6b575745f0aa62dabff329c41fa0b44d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a243154ac04bccb01591b0f07c7c56dbf86e48ffbdea0d296295f7a91f18ca82"
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
