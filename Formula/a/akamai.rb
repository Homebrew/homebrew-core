class Akamai < Formula
  desc "CLI toolkit for working with Akamai's APIs"
  homepage "https://github.com/akamai/cli"
  url "https://github.com/akamai/cli/archive/refs/tags/v1.5.5.tar.gz"
  sha256 "39ad5ac0a0f0c7cbf24e0e4af9cc74868f39e41d632b236d8ac4bb5ac8d2969e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ca5cc96a4f75f61066b59b64f8a61533500e3e5a1b291870117ec898957cbf4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ca5cc96a4f75f61066b59b64f8a61533500e3e5a1b291870117ec898957cbf4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6ca5cc96a4f75f61066b59b64f8a61533500e3e5a1b291870117ec898957cbf4"
    sha256 cellar: :any_skip_relocation, ventura:        "15bdf852e4fcbec53af5d758a6613075c96b53e7d306dde2e631d7892af2ce0a"
    sha256 cellar: :any_skip_relocation, monterey:       "15bdf852e4fcbec53af5d758a6613075c96b53e7d306dde2e631d7892af2ce0a"
    sha256 cellar: :any_skip_relocation, big_sur:        "15bdf852e4fcbec53af5d758a6613075c96b53e7d306dde2e631d7892af2ce0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2157ed6f76428807b044cdaf48023c6fa6222c5276d1ff4a2a36d3a7e6149aad"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", "-tags", "noautoupgrade nofirstrun", *std_go_args, "cli/main.go"
  end

  test do
    assert_match "diagnostics", shell_output("#{bin}/akamai install diagnostics")
    system bin/"akamai", "uninstall", "diagnostics"
  end
end
