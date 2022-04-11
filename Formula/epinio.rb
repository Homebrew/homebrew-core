class Epinio < Formula
  desc "CLI for Epinio, the Application Development Engine for Kubernetes"
  homepage "https://epinio.io/"
  url "https://github.com/epinio/epinio/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "e70e0ecf4665bcf840a97a47409580b5c730ef5f711a17d4a3f03841c96cc178"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3daae6db26e9bbf122c2175336aa198ec0207ba8c3981567f0dd96f449e9153"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b10aa69b3b2e34e19ad099deb49c6b01baa0e0ea0ac53d31600ea37087b2e46d"
    sha256 cellar: :any_skip_relocation, monterey:       "56d52ab38a49daab21d916a626a8446c356ee08a700ee2a93f6f8eeef0238c80"
    sha256 cellar: :any_skip_relocation, big_sur:        "30fd11e5b25f63e59e107f5dff52702c09157e2ac4d7739dce90b55639752da1"
    sha256 cellar: :any_skip_relocation, catalina:       "d313ceb1461311d63cf9188fe575bc539d6e8049e60df5508465889883ece0d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fed07091b48ec41920b77db061098649f1d5dc15ea8a154551b42dfca4856a87"
  end

  depends_on "go@1.17" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/epinio/epinio/internal/version.Version=#{version}")
  end

  test do
    output = shell_output("#{bin}/epinio version 2>&1")
    assert_match "Epinio Version: #{version}", output

    output = shell_output("#{bin}/epinio settings update 2>&1")
    assert_match "failed to get kube config", output
    assert_match "no configuration has been provided", output
  end
end
