class Microsocks < Formula
  desc "Tiny, portable SOCKS5 server with very moderate resource usage"
  homepage "https://github.com/rofl0r/microsocks"
  url "https://github.com/rofl0r/microsocks/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "939d1851a18a4c03f3cc5c92ff7a50eaf045da7814764b4cb9e26921db15abc8"
  license "MIT"
  head "https://github.com/rofl0r/microsocks.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a897bf8b4ab23861c2fd23b129f7562da267b7cdf389e7626a42b786c3ab7c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ca7d350608642d885c328e674d2e344f0d133845aae976f426fa4796db88fa9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28592464e90d74dc434146ad23e1a2d8ba86f12ed45e0ebdf65e31b1deda204a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9db6e466fd62a65dec737bb317de8a2651abff75e6e15c3df07eb3380df5e6c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd1e474defa7ff10d8effbaae96178ab7698e53c8ab365895b46f19e9aa450d1"
    sha256 cellar: :any_skip_relocation, ventura:       "c2daa6286809fc95087de6650afd34d977c0f717fc5b2fca4abce58ecebf9e80"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9d5c4ce96b7e33f52a23d435741c367c056a83ceb84efa8d38059dd6a4e252a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da9b7567d172d896cbf1b8040de3801a26c25608259428a3d7b1a12b0bae6a4e"
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
