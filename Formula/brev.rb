class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.68.tar.gz"
  sha256 "9c913dd1fd961514029763110e7b6515eb1ff396a66a7f22eca1fb0723982137"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd921400d1daabfff9ef2176ae8b183b7faa185fa8a202de4360bdcc214483c3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "87f85e11e60224e41a43d04830b4087df8d9b8d6158f80387112dcd7522e89e3"
    sha256 cellar: :any_skip_relocation, monterey:       "af4b29ac80cd5e93ec41388cd9130e55a9ad63e26516cbe80b415a1bc4b63613"
    sha256 cellar: :any_skip_relocation, big_sur:        "2bee00c67dbb7652a316983f67eda23bb7bbb72370412455a690df8d324e79d0"
    sha256 cellar: :any_skip_relocation, catalina:       "022997af99ee793f7ab1c17c2517ceacc4fef9e725f134d25500df73a89923a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "753b98bd68e1b107bd7488507b0a24123940337555da6d55f786d1b065d223cc"
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
