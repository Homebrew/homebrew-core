class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.170.tar.gz"
  sha256 "ecc2272f7750356ac9840df520e1c57424026ae8222fb54e50aa1a48be73d265"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c0dc41862ea6507ced3ea58659a53cb18ae19a378cf1ddc54edfd6c244832c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d39cde8afd752507ac2c8b6991828b7753d94d1da00e6c089e3c57ff7be3941"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "116c6fd1e544f837bcc49fc0be47eaf58f9e0c5b73969a724a89c2696f159e3c"
    sha256 cellar: :any_skip_relocation, monterey:       "a4834e588c8eb9ec4b3d61c90922dee5d26169ee1732f865b2c8ac6683e0a921"
    sha256 cellar: :any_skip_relocation, big_sur:        "b7e3ada3b44992dc00ccb590f771cd2ad9cd97e52ea83b8cae547d2c50bc0a47"
    sha256 cellar: :any_skip_relocation, catalina:       "7ae5441d7ae0fa28ecf1654a624ec2f7a76b34ecb418598bb29953dcca0f6036"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0870957979ca177723e3d28dba3a921a2cecc55be4aa0a82c472408b85aaa45e"
  end

  # Required latest gvisor.dev/gvisor/pkg/gohacks instead of inet.af/netstack/gohacks
  # Try to switch to the latest go on the next release
  depends_on "go@1.18" => :build

  def install
    ldflags = "-X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"brev", "completion")
  end

  test do
    system bin/"brev", "healthcheck"
  end
end
