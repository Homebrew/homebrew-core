class Akamai < Formula
  desc "CLI toolkit for working with Akamai's APIs"
  homepage "https://github.com/akamai/cli"
  url "https://github.com/akamai/cli/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "58269ab6ab93a4b4e0a773fd62efae5f1aefc74fc6bdfcf0fdf5dbce75998146"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c04de087fa3bf49fb5239092e2ed831443c05747454a92b7c8ed17a2efb3ec35"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ac792120d6f52a46a04a536217af4594f2dfae11e96bd3020b22e97c17a494c1"
    sha256 cellar: :any_skip_relocation, monterey:       "616c69e301a7525d974fcc30c0d64359d5d5e9e151fcefb661142e0fc98dfe5a"
    sha256 cellar: :any_skip_relocation, big_sur:        "cfe705aa36be796ef2144ab07b78438e08a9477ec40c2908ff510493088b3283"
    sha256 cellar: :any_skip_relocation, catalina:       "3107e221c3b1c4b5ce873bcfa2db8195214c0819cf70820c3e57935135fef3ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d24468b68f88b0a87d9411672f9f644bc7f528c7be70d56160d9e5fb7d2dc8f9"
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
