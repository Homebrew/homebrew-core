class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/"
  url "https://github.com/iotexproject/iotex-core/archive/v1.8.4.tar.gz"
  sha256 "24e5ad9ce320a838948631d38d094bbdd727aefe216908fb1095b06533bccb64"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "238bbf68466c2a0ffb4057116658d2f664ca6bfdb75f99dfe841fe12ee82474b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8648755e9b80d98587fd01d86c0815b43bca7eb5ffc3517234d6820741f4e7ce"
    sha256 cellar: :any_skip_relocation, monterey:       "233e7f64948cd1d8ed98995c295117a62389e1d3a66a1b13de347a4f086a3140"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad1494fff0f4b040027c2b90cfb829de49499243075e1a1b492ef40a2e125887"
    sha256 cellar: :any_skip_relocation, catalina:       "a703e25f13c3a223e51a65b41b77c947303aab5bd6f5fc3b3e45084438f8bf4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4a8173e54c8097a6d1f91a4c880ed63ab13a80ccfb1be05799c172013ecd389"
  end

  depends_on "go" => :build

  def install
    system "make", "ioctl"
    bin.install "bin/ioctl"
  end

  test do
    output = shell_output "#{bin}/ioctl config set endpoint api.iotex.one:443"
    assert_match "Endpoint is set to api.iotex.one:443", output
  end
end
