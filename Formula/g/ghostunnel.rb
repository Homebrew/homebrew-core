class Ghostunnel < Formula
  desc "Simple SSL/TLS proxy with mutual authentication"
  homepage "https://github.com/ghostunnel/ghostunnel"
  url "https://github.com/ghostunnel/ghostunnel/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "b4eced76660e5e4bcdead3a3026608d500576fac574e49371cf9de8c98041b71"
  license "Apache-2.0"
  head "https://github.com/ghostunnel/ghostunnel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f6456eea77410787d8fe28c7f9cae2ae8624fbaffc2fba2e06d11dda74b3bc9c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b66f6e2fec5210fe2189461b3732ff558386fcc98d0850442a5df862bdec0910"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d37b5c7e36c2192474cbc43bcc966af03534f8c8ab7da0ab192aae4e3650d8f"
    sha256 cellar: :any_skip_relocation, ventura:        "9fd269914394018868615f572f955d0d0cf733565ef51715ce8c33e0806b440c"
    sha256 cellar: :any_skip_relocation, monterey:       "7ff079fa2a391da1c5e3cae5b8a117fb8d6db3ab0e0998961cd2253339eb9f2c"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a675c369ce55275aaa2905e42b1b2ef2f14d1bbc0fb08ca681b442caded0e7b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    port = free_port
    fork do
      exec bin/"ghostunnel", "client", "--listen=localhost:#{port}", "--target=localhost:4",
        "--disable-authentication", "--shutdown-timeout=1s", "--connect-timeout=1s"
    end
    sleep 1
    shell_output("curl -o /dev/null http://localhost:#{port}/", 56)
  end
end
