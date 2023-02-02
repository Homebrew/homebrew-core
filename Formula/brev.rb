class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.204.tar.gz"
  sha256 "6e3748ad5fd286eac49186f2a97140e3d5a23a3b3eb741f854b5a5ae352f5370"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d65bb0db4efa05efa990fc319e375ebbd0468c3a5f500a4044c788910d0e53b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90029a9aa098b8cbdc0af6358f88c14d5197c6c3bea06508333fd0c4378ad0ca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d53b3bb196f07db74a68db7931f8bd95e080500dc9be3d4cac1f721cb03dce00"
    sha256 cellar: :any_skip_relocation, ventura:        "7471b50872dc042c000cd245aacdb5d83a50afce9a2091afd29ae6bcdbe464f0"
    sha256 cellar: :any_skip_relocation, monterey:       "c96b6ea0c3336b401f497a04bbfd11abeec849d0e394230f8620b0174af6bd23"
    sha256 cellar: :any_skip_relocation, big_sur:        "bd403468dc967871820c30d5637f3b45a8eeea567e90160bb4698f5f4a52b86c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99663b5a49bf921795e87af072ea8913685ab646e353ee0d4c037b304703eccc"
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
