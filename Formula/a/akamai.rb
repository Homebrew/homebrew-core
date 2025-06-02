class Akamai < Formula
  desc "CLI toolkit for working with Akamai's APIs"
  homepage "https://github.com/akamai/cli"
  url "https://github.com/akamai/cli/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "c9fad288ac1c45946f9ebe8de28c0bd47646d0033ae15d4cafc5f9bb472d6b94"
  license "Apache-2.0"
  head "https://github.com/akamai/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b915d193b1283f0ad602de2d6b8b1803841801b8ef437f2946e44f3b68208f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b915d193b1283f0ad602de2d6b8b1803841801b8ef437f2946e44f3b68208f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3b915d193b1283f0ad602de2d6b8b1803841801b8ef437f2946e44f3b68208f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c58192af7a10223a6a0d2ac49bbe2b44ba8b77b780677263cdf6f7c111e2117"
    sha256 cellar: :any_skip_relocation, ventura:       "6c58192af7a10223a6a0d2ac49bbe2b44ba8b77b780677263cdf6f7c111e2117"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce4711c42cbe0383cac485f7bb0e83c75c73b23a36e38d562d882578302f21d3"
  end

  depends_on "go" => [:build, :test]

  def install
    tags = %w[
      noautoupgrade
      nofirstrun
    ]
    system "go", "build", *std_go_args(ldflags: "-s -w", tags:), "./cli"
  end

  test do
    assert_match "diagnostics", shell_output("#{bin}/akamai install diagnostics")
    system bin/"akamai", "uninstall", "diagnostics"
  end
end
