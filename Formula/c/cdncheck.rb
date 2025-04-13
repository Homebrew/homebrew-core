class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.1.13.tar.gz"
  sha256 "632589b424e77725f12f30f2ea7de8ae11333b1b2b8f2fdc9f4af4c27c114f98"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c6f67bace6360350fa2c5ac8a3caa69ab59f926a4717b9cf3ce65f27aa931c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d3c096e1f8633c156d05981099ace447c7f81c694be33ed5050660d3ea6b315"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3fcd2a4fb5b7402ecc193d487d625a08d432ff452bbdf9e918450fe4bf5668be"
    sha256 cellar: :any_skip_relocation, sonoma:        "52d4ec5fa4347cd6d0c9578185d8d034a5f511b2a420492f5d35f69d18f3ee0b"
    sha256 cellar: :any_skip_relocation, ventura:       "d819cc7d765ec4d6521c27837040588416a52076f9f05d0b193e7ecdb0ea9c16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5513de78861a46e147b073adb210c07f87cb3479d898691ccc152f2554abd905"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cdncheck -version 2>&1")

    assert_match "Found result: 1", shell_output("#{bin}/cdncheck -i 173.245.48.12/32 2>&1")
  end
end
