class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.42.tar.gz"
  sha256 "c0982aa561717141ddf20f67c3508e7fd0fc4cf6c0512ef87661628db6f60745"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01c96298fe35a26aacc1c2f2870d4e087ef578d35aeba6c2bc078ee55739ea46"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6efdec7e07bf1d9e3df6fb6b04f22b9d234b9f72d87645b3f99c5b2aff768f86"
    sha256 cellar: :any_skip_relocation, monterey:       "686c75e53bfe295cc0b24f1e704ed30d60afa1df322174e77a901156deb15f60"
    sha256 cellar: :any_skip_relocation, big_sur:        "f3488d1b4797053e06107a4aa92cf4979cfc13eafb6ef10965ab3038a9110da1"
    sha256 cellar: :any_skip_relocation, catalina:       "9e9d83bc9af58d3ca21efe2882fef5f1e3ef7c79f77361bfaf0f95f612eea3e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "774cdac18eb5d03a8a0e41de916312dd9e0e7e9ea348c3fe7123dae3acf3a288"
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
