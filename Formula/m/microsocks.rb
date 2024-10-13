class Microsocks < Formula
  desc "Tiny, portable SOCKS5 server with very moderate resource usage"
  homepage "https://github.com/rofl0r/microsocks"
  url "https://github.com/rofl0r/microsocks/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "130127a87f55870f18fbe47a64d9b9533020e2900802d36a0f6fd2b074313deb"
  license "MIT"
  head "https://github.com/rofl0r/microsocks.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "07631a110ef56b6c8c3e4a6b8c85d164887354193b9e58e3b64be7f0e5cc3a26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9f810e991f89efe41251e4b279c3acc7ad9162b277626ef583da651a3efa2415"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d93dbf5c70af611d6a8cd913fe2d10c45a8b71d0a77c91eb5a2e4fc960caebb5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c52e86caf306cdc0a23441f96c38559b69c0f8b1e1104990a3f87051d860f6e"
    sha256 cellar: :any_skip_relocation, sonoma:         "6cdb6bbb1ebca5b3e12df5df334ca8ce23cc272bfb81afc1ecfe69bcbbf84041"
    sha256 cellar: :any_skip_relocation, ventura:        "4132e8ff871b994ccffc35fd5c2534af6793bbe4cc2b6a2163a9df54bd75a0da"
    sha256 cellar: :any_skip_relocation, monterey:       "690acb24c9ec24c0c646ba60e5ae95164735240d48e473e33ae3ef1ca38d6ade"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "379340265a1a559df23609b12a525d32d1d71dad8722c1f03c6cc9223390adef"
  end

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    port = free_port
    fork do
      exec bin/"microsocks", "-p", port.to_s
    end
    sleep 2
    assert_match "The Missing Package Manager for macOS (or Linux)",
      shell_output("curl --socks5 0.0.0.0:#{port} https://brew.sh")
  end
end
