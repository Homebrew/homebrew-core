class Akamai < Formula
  desc "CLI toolkit for working with Akamai's APIs"
  homepage "https://github.com/akamai/cli"
  url "https://github.com/akamai/cli/archive/refs/tags/v1.5.4.tar.gz"
  sha256 "994b09e6d735a1b2512416ccfec7eaf7440be1642ac903f02a3dd7dd09eede8f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ae94983580f91eceebc9f821b2bb92059098786835f3ef6099d901c8fc7a39f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ae94983580f91eceebc9f821b2bb92059098786835f3ef6099d901c8fc7a39f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4ae94983580f91eceebc9f821b2bb92059098786835f3ef6099d901c8fc7a39f"
    sha256 cellar: :any_skip_relocation, ventura:        "8eae9a2e9d388a5792f39a24963339909069caaec8cfc3ec76437b0d9642df8a"
    sha256 cellar: :any_skip_relocation, monterey:       "8eae9a2e9d388a5792f39a24963339909069caaec8cfc3ec76437b0d9642df8a"
    sha256 cellar: :any_skip_relocation, big_sur:        "8eae9a2e9d388a5792f39a24963339909069caaec8cfc3ec76437b0d9642df8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b155a8ff4e558334604dcd8e602c0da91d42108ae059b20039a1eb2b341f145f"
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
