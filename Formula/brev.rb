class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.59.tar.gz"
  sha256 "decabc7cff6eeeae17ee2dc7f5725845f88edcb4f7eef651f1ca48b39150e604"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c32541da3a0adf9a09e3782bcac15865e12c16a2c3df1753c565ecc6809d74f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e0bd09065bc722c935cbff065c21402e934f23f040d3c4c81fe99eada97edfb5"
    sha256 cellar: :any_skip_relocation, monterey:       "ec8efab059b7b035348a91a6fc4bc1f3ff445a08a0bc678cb487f0b779405987"
    sha256 cellar: :any_skip_relocation, big_sur:        "295a410c1112c0f78bc683196dfdc0b03844ff81a19c6872af0b103eb9e7c86d"
    sha256 cellar: :any_skip_relocation, catalina:       "24bda531d8e1d0ce237eb5f0d802319947056a6c42d574a5ef4e40202e1cff97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7fa1dea2a9cd483466d76ee1d27b40a66ff0e83d086f1caa34e8b9394fdd378"
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
