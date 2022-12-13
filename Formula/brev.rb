class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.191.tar.gz"
  sha256 "4aa6d4e73b60905a1209cf162abd490a7eca026838cf43e8de087f4fd02feffd"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04d6923fa7c0dcbcaa070a8958e75139c2bd312ccad98fb86926c7ed31f3bc24"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75f09bedb2620c00d13670f5277cc439e6bdbabe4378763bf2181e79f01aa78b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bf715ba16fdb0a04cc01f67ad8920f4c3847df0d601eb6832efeb54bd6c72838"
    sha256 cellar: :any_skip_relocation, ventura:        "57063e1d5679650c5519c61edbebf720bec28a879ffc35b0d1e381644a6d9f6f"
    sha256 cellar: :any_skip_relocation, monterey:       "1efe6540937aeab4189740c3acf4a01b8883fd392187fa1cbac9f79e72031b2f"
    sha256 cellar: :any_skip_relocation, big_sur:        "3778511eed3b9d93fd6e124c8bf7a2cc08081e25c26a7ba56c91950a6984ee06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06f8b015fa9e7be00ca5d2b3e7d0c1c1dd3cffdc6ead51abad3a7882b59cb0b0"
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
