class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.208.tar.gz"
  sha256 "3b37a978060115c5676e5d9d0557c865b7ba58ba4d6d4f31f2a8aa4176bf5f2f"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2fde4a22282650f0cd0ccded52578ad842ec15555025ee8d85a6618a9d9613f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed45327c53dde98e464e0ec02088f9533ac8e2e31547d630e8fb3156db517e0f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0d4220a39df90a0035af8c432338415088ea063c244a1807f137858b2a3ac24c"
    sha256 cellar: :any_skip_relocation, ventura:        "5addbf67241eb0ebd4912bae102bb180eaf1e918cabf2ce42b81c9246e3d5840"
    sha256 cellar: :any_skip_relocation, monterey:       "15051dd2437a5123b622558a3b553ee3d2df60e482c3d6532062d4f945dfdefc"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a08fdc0725a8eb60c709a4c015e4305293fbf6577eb91ed512843d313f2d298"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "941831bcc325ad945f4bcccd77894a92e72ea1eba1f31146153768b657668a51"
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
