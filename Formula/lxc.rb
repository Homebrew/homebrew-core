class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-4.18.tar.gz"
  sha256 "b60e09e4d349eebfedff8f1ca493533fb7353aceb43cbbcd7f4e340715a5f3a5"
  license "Apache-2.0"

  livecheck do
    url "https://linuxcontainers.org/lxd/downloads/"
    regex(/href=.*?lxd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "37b46913ca4af3a6de2423432f38e6e894db775ea2c802496b2d14608cf124d2"
    sha256 cellar: :any_skip_relocation, big_sur:       "9f755f476ad13aca974fe9ce0aa8f6fb24a0ebbd8aa8eeee90c6f0908cf6178f"
    sha256 cellar: :any_skip_relocation, catalina:      "cbd593b852065b84524ec5ba2b5a887915de7b8d3e6be5ac3df206932627e7ff"
    sha256 cellar: :any_skip_relocation, mojave:        "741ab3a57abc315b92f8e831609598721ac1ad98b01e4161b914d9e5c630e915"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd354e5877ab407ea981bb9cc86d0a581770b580e3e7027ee62e8b991dddba19"
  end

  depends_on "go" => :build

  def install
    ENV["GOBIN"] = bin

    system "go", "build", *std_go_args, "./lxc"
  end

  test do
    system "#{bin}/lxc", "--version"
  end
end
