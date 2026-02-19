class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.2.23.tar.gz"
  sha256 "974a77d84e554960e981d0996ba32728d6d990242793821b890b152a89a6094e"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f5591cdeef04a81483d75ee6ed9ee8ed39cc864d6605fb0232a2b123343fe60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f3757225a6758927b76c60a5a6d014307c44fed30b1dad3c6d14c661bf70cb9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "130eeef71eca1eeda546b0328fff137bd78170ac3f15f9528b583b9db682b086"
    sha256 cellar: :any_skip_relocation, sonoma:        "66fb7fc59620b9fa4d3e827deea55a41951f01c24b8785208df5ac9296cc0784"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0d24fe25d9788519074299c0d5d12002caf3b711634ce5c67c8a651b08b9151"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1db44fc59e784e24410f2d8556954f0eba908db98832b4cd91bdf20d385a4b04"
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
