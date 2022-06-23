class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.80.tar.gz"
  sha256 "1e8a246ce9211ad08f4be6d1f50696980b537a445b735c2193635409c31c6ba1"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "836d792334c9fa6a8d5914703f9297cf6d85171ab8a05ec3ecd0b7d9b5d90fef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ed32109c1a7f7ddc47a47b5eba8919bdc4caf653e3310fce4e68959125110735"
    sha256 cellar: :any_skip_relocation, monterey:       "4a10451c3557ba94352a1aba95c6263c4af14240b393a86486107cc836672832"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc05e9007e47c111d88712227e3f56d4a21529b21949c0535ee4882d42ce8d94"
    sha256 cellar: :any_skip_relocation, catalina:       "0133c3a12ebe06d3b92ce59fa940139b413cb6e90a9990db1cca2ac6b448c06b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a59268e0b1f93762126d3b19776e78a9a03d580102ccb04fec4ec826139f585"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    system bin/"brev", "healthcheck"
  end
end
