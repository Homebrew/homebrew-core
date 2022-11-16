class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.179.tar.gz"
  sha256 "555c2338abf8a5b6600cc482a7b2ba6e0643b08f62f62e295b206b6c65a600c0"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a673c88ac2d46bcd4502f26e0e62d04a25de811fea96f87f83d8ec9cda1bd3a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6be4ff554092ef157bf3cb6cde9353506d9a5cb79e18a74d3ff12f267ad321d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3ab302e6ecc7febc3e56a153ec833069ca6894dcaa7623614a906c692c42b75a"
    sha256 cellar: :any_skip_relocation, monterey:       "ceb3da83508bd037f460ef4895011ef434d9b42ef8c8500dc8935ee413d7fc31"
    sha256 cellar: :any_skip_relocation, big_sur:        "19634389c0bfe521383d8fb19c2b18abfd371db3f604b1712022404881c59cf0"
    sha256 cellar: :any_skip_relocation, catalina:       "a96b158bfff88c7aad2d7504f691ac21d149187c6900612c9f9873f72108b26a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71ac23979c0330a581ace5b6c7f499b716c1b3ac687e81f5813bd18c7bf9558c"
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
