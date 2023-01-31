class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.202.tar.gz"
  sha256 "96d7f28cc54632062004d831c0e350d02ee8d932bd5deeafc79579605e751ecc"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cfb860c3b8f8814f82bb73b4af0fa576ed9e3a4b533b28bdd1bca95523bee891"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7cc44594ad6fd29eae9a40cb3cb9ca4e6ec5b8ed32904cd29c235faddf2c4545"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b1d3ae287acdeba956be239ed7c3e5c2e9c7a4b9d284e472ae93b58db4c3e380"
    sha256 cellar: :any_skip_relocation, ventura:        "3fefeb05a134af98eaccae71b60ea054056a86bf18d7883cac3bd4fdecec4399"
    sha256 cellar: :any_skip_relocation, monterey:       "b39da541d448454ca034168c5392a6871b8f74043cd6aa50be93ab9630b2deec"
    sha256 cellar: :any_skip_relocation, big_sur:        "a24b0b61b8338919ae8866f8e379d7f37d4e3ad667dcd98e7228221b0e00932c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f05262ac7485d210a7b120531765c16be7cf8df6880eafad13e3b89987e24157"
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
