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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "374c83e5592b8ebb4d8683a7bcc18400adac479088f667a3d0e28743191cda4e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d87041921213beae7143699d396259e8e037391a5c21749abc67ea952699d127"
    sha256 cellar: :any_skip_relocation, monterey:       "42db2103621a54f677520ff3f055d7cc12aee0b6a72f65227ec61eae6835f40e"
    sha256 cellar: :any_skip_relocation, big_sur:        "56cd4cdfcb2d748b4fe3553c5dc2027dea131460be8b75d072ec9e14e726c8df"
    sha256 cellar: :any_skip_relocation, catalina:       "768de0f0e873677eb6b99f32ebeaa96d5f7f0afa1bea9bc602836f03fc169e40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7025a032b67f8bf86f4bf00e9b8f652321e3c26b69d0750628b9a76b4bc534c5"
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
