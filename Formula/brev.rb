class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.81.tar.gz"
  sha256 "33d4d56f66b3923333e64da5151f92b1c186c644c4ac69ca357567aed035a42c"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14c93beb73c66e8e31f4c76cb6b65818a69c66db1690c876512aa6409aa4c5af"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "395f02d696465ac80a1bdce2fbf8c31017f3aa877fdced446feb47ba46006967"
    sha256 cellar: :any_skip_relocation, monterey:       "7f28b55ab10a00ee6038e4e5b3df6813aa4f4c07fecc1a3fe5be5eb715a4f02e"
    sha256 cellar: :any_skip_relocation, big_sur:        "e515eca9d32193ee57de1e00477493e9da050abcc895e1a11ee13c574a25d108"
    sha256 cellar: :any_skip_relocation, catalina:       "2c913050b6f54b12a9f2d9fdf97c855d591978094458d94520dc126d95e227da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be852c4b0444930cf84c4516e8b3258da1f694e354d5570827d902908be1ede4"
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
