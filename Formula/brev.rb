class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.44.tar.gz"
  sha256 "6c11ecb7dc80ae0433b32ebac0ea77baac55fe71a1d42d0a49f6e929d444134f"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e74f927c300aaf307b7db7daae79a1ed58ba08b3ad295654853b20b3db266bac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3dd5bcab40ec7911a7ab39b9b17db224cbc86aeb91c22f88166533cf90e8b061"
    sha256 cellar: :any_skip_relocation, monterey:       "c655b04ccb951641f84d5c4cce2097f92059e4d178cab40710cffb1193ea5566"
    sha256 cellar: :any_skip_relocation, big_sur:        "90b5b50ebf2e1c894abeb5aa9a112bb29af79d6e308193fbba8f07181e7492fb"
    sha256 cellar: :any_skip_relocation, catalina:       "7b013c366c49156370c6f762f595130052a6f7eb01a66d6500e8bdc824aa4014"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d6d23454cd7a3a56759a6a43c227ae0340ebfda55b15dbd6de51b4e6da8faaa"
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
