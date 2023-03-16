class Akamai < Formula
  desc "CLI toolkit for working with Akamai's APIs"
  homepage "https://github.com/akamai/cli"
  url "https://github.com/akamai/cli/archive/refs/tags/v1.5.4.tar.gz"
  sha256 "994b09e6d735a1b2512416ccfec7eaf7440be1642ac903f02a3dd7dd09eede8f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "617b4c72ca260724de3ab2b3b6de234b302579edb5d00d8d97d56689a9322348"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5edb68ea70e7fba65c26640f0594fa8db2eca89a40447e73ff5d5f604088fc56"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f8d828dafe5e409b7d0ff964dd6e131c6ec7b1a2ff3b7dd8d9a57e19ce36b126"
    sha256 cellar: :any_skip_relocation, ventura:        "4df1ccd471231dc97cdbe3c85bc3230c9a08ad64ae88518789fd96fa3ba3affb"
    sha256 cellar: :any_skip_relocation, monterey:       "7d074c2459c4e50ad30dc2422fcfe7958b455a7a3f2de7de2266f08f94fea856"
    sha256 cellar: :any_skip_relocation, big_sur:        "8e88ef7de0d57eb8703e720c4aa06b83e97a9b1a512d2573032de136e906089b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16b8d05560533d0608a17a5be9e70f9d89c7829612c2b78996a2cdf7adadf72e"
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
