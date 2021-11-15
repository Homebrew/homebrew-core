class Microsocks < Formula
  desc "Tiny, portable SOCKS5 server with very moderate resource usage"
  homepage "https://github.com/rofl0r/microsocks"
  url "https://github.com/rofl0r/microsocks/archive/v1.0.2.tar.gz"
  sha256 "5ece77c283e71f73b9530da46302fdb4f72a0ae139aa734c07fe532407a6211a"
  license "MIT"
  head "https://github.com/rofl0r/microsocks.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1281153db801e84fd1db562c877cf3537412cd86e029de0e5ea1846eec8c7dd9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ac28cf21d02ba3d7d48950bfab977718e5aaef2eac6e19f0885a5e54cc5bdd92"
    sha256 cellar: :any_skip_relocation, monterey:       "ce98ce63848e856cea90e0e75eb435a7aea76cce34c8c8c5b4ef8cbefe09e669"
    sha256 cellar: :any_skip_relocation, big_sur:        "f80592c439fb03b85318e2356ff0c9481b0dc6643b4224697f359fcbb9d585ce"
    sha256 cellar: :any_skip_relocation, catalina:       "95c80ff1e1fe1f25efa6c5bd2498c969575978c0bac2935b293ae1dc6a0cfef5"
    sha256 cellar: :any_skip_relocation, mojave:         "007187db61ac04906954220f606b66d23d00d04457ce94667b0f59f82ac1bfcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4356d57b9e923021407147fb19c46d36223daffc5ed6c2475eae751ca70da3a5"
  end

  def install
    # fix `illegal option -- D` issue for the build
    # upstream issue report, https://github.com/rofl0r/microsocks/issues/42
    inreplace "Makefile", "install -D", "install -c"

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
