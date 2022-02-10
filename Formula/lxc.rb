class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-4.23.tar.gz"
  sha256 "6cfcc7f4c462ae09776ffc24918211844bebcafcbfe4cd98f4b2cfa83e082fc5"
  license "Apache-2.0"

  livecheck do
    url "https://linuxcontainers.org/lxd/downloads/"
    regex(/href=.*?lxd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30f1d018a25688546815458226ee42faf6de541d0de98d6e86f3cbf19ae2013e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3bafa1a486a8cc0e8183131bdcfcc5b2342160591be03ab0c973d465ed18c22a"
    sha256 cellar: :any_skip_relocation, monterey:       "6a59d4cc1cb141ebfe9deab4ba6605babb3b63cf8764e34d1f134a3201b952ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "a03a63240c973fc076ce3740dbaf53f1b52c865146bdb4f4b8d06974cd7e9ec5"
    sha256 cellar: :any_skip_relocation, catalina:       "ac7d1a8f6c1513aba3c005a72b9bfda5e956bdbf83b9dddc7db7c9950b933f85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "456a3a018fcce3e33df01dc33e5a3949590c52df6b73037c7e56e98fca045553"
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
