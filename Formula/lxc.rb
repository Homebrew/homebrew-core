class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-4.24.tar.gz"
  sha256 "97fae15a1826bc73a45cbf8e9adf775fd9702248863b8a5997de5494eaaeb252"
  license "Apache-2.0"

  livecheck do
    url "https://linuxcontainers.org/lxd/downloads/"
    regex(/href=.*?lxd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e618c398667bc24ab1ca30b66c54352c497a376d66d3ce7149372bc2f0d9c69"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "00a3e3f5f3a8d63f344cefb59e8899f8b470d695792b5a2e62bac93727c688b4"
    sha256 cellar: :any_skip_relocation, monterey:       "180ea43b3bb7419f296b736a9b89dbfef2795fb92439ec9f0915c607673585e1"
    sha256 cellar: :any_skip_relocation, big_sur:        "d30aa92c6dd523da6a59fb42a63ae3c1c6788a5b54b8b60614cf858d2f7f5ec1"
    sha256 cellar: :any_skip_relocation, catalina:       "4e9d25e0bee30fbf4fc629ba2fb1fc9fb9d951e2b429fb41e4493ca1e100e596"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ecb1bb35dcd51bd211e36043b8b3ea965ac91e490737b812d91532e8e618229"
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
