class Grpcui < Formula
  desc "Interactive web UI for gRPC, along the lines of postman"
  homepage "https://github.com/fullstorydev/grpcui"
  url "https://github.com/fullstorydev/grpcui/archive/v1.3.0.tar.gz"
  sha256 "56519818d08a47339dece319cb4c8387a65bf24623f49242ef6a1201a1eb8b15"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92ee93e6bb82f12c6238f55ae55465c2e8670df73e0e274076b756585500baf6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cbc6e8ea1c901b3f2e80dd4ce741c21bc777af0cb1eb8e8a70ffc1d26a3edec6"
    sha256 cellar: :any_skip_relocation, monterey:       "5e9846be4e13d39bc87816223e996dcb136f28e3a4e8ce7598a2e27d478698fb"
    sha256 cellar: :any_skip_relocation, big_sur:        "8bec43db862a568e2fb2a075bc46970b2c726299e601d03ebb16aa076bac4c82"
    sha256 cellar: :any_skip_relocation, catalina:       "c6fcc7943283586878aeb88d195cbcc7175f7d3a087e9a0f09571e7ed3b21ada"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "766d62495f451b0d028066dc7bed889947c6715b0793992a51b2eaef69f44235"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/grpcui"
  end

  test do
    host = "no.such.host.dev"
    output = shell_output("#{bin}/grpcui #{host}:999 2>&1", 1)
    assert_match(/Failed to dial target host "#{Regexp.escape(host)}:999":.*: no such host/, output)
  end
end
