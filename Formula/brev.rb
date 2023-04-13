class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.216.tar.gz"
  sha256 "451c6ea50229f1454844186b6fe909a3adc95faffc793ab422a6a8530e5ee027"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cfb4646f903e36972261a5610379462197da129153e67cc7dc5b2340ef9879df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa6eea852015d442c1fccb58417dea1ff1e602b403da428a9bfd5814bdc1bfd5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "45ad03a1efa8e63e11ba759cea2b7f6d74ccbb976ac05a46d4905e157035b247"
    sha256 cellar: :any_skip_relocation, ventura:        "f4eeba01fddb9811897a114e0aac62cd9b95d62cdbe45eae4b26d7616cdfc5a9"
    sha256 cellar: :any_skip_relocation, monterey:       "0a978b5bc1072a0c8a780a71b8bee28befab85dd2b0e842cefced5ac6e82f029"
    sha256 cellar: :any_skip_relocation, big_sur:        "b9dcf33534834d4c77d07d63bbb2e4a004a5a028c2f4edd7c70603463c020ecc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c6dfd426bce30642f4eedaf241095fff755c2f7d1b9df048b5e06a10cf1f260"
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
