class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.203.tar.gz"
  sha256 "7655bde3df0cbde2d14ee930cfec8d4ca6a47e4061e023ec7d6e33997c80e88b"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5913ff07b148ffb66726550ed73180987f37b5cba6b819fa60e08a7e0c4a083"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5495c7d431137206c88b13c0282af4076f9988b59a72d010d2f1aa8d1e8828ca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f4d882d52d34c64edb1eb9c20c3b6b5f2b1c806e32439c5ff7466071becec347"
    sha256 cellar: :any_skip_relocation, ventura:        "541619d0c1d57c50d9506a9a19f55ea552e486826070159d22faa5843348f6b7"
    sha256 cellar: :any_skip_relocation, monterey:       "4caf8a2277dc0aa4320620802cc7d9d70963672619d19e13c622e3c230d7712d"
    sha256 cellar: :any_skip_relocation, big_sur:        "8186f7463dee6c884b5f11cd90fdcbb8a777bc8dd3970cd682cc9249d6bda4ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3419dfe066b383fb3ceb74b77df5d3ca9acbf2adc48e20ce9887bcf9be8ea75f"
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
