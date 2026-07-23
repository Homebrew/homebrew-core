class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.2.45.tar.gz"
  sha256 "ec2381aeac4722642ab34179ad59cc26e5ce75343ebb0decdb96a6e33c5be5d0"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a5bc82379892c45422631bfb5609058752242dae93ab106c609a1c3587a179e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "806e20480ebc0a38e5800a32b0613c3a8cf7fcf0f02d8c35c6a4978f91ec1146"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50d950f989682d793bf2e368bcc38c0dde10b3a5068198858f30be07f035a2dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "743f672872bfb5d4b1ef6de1732a968553c17ce0c6271f5e024cccc34b0251c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "feeed5fd9330d23b9f13fe7ac4333af9239f817e7c3c61c52d2ab1143baf4f00"
    sha256 cellar: :any,                 x86_64_linux:  "b78fda9504142e695162e9658bbe803c724a615eec74c87a9adc62f8038c8db4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cdncheck -version 2>&1")

    assert_match "cdncheck", shell_output("#{bin}/cdncheck -i 1.1.1.1 2>&1")
  end
end
