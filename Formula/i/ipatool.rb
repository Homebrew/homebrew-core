class Ipatool < Formula
  desc "CLI tool for searching and downloading app packages from the iOS App Store"
  homepage "https://github.com/majd/ipatool"
  url "https://github.com/majd/ipatool/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "6bffee11fabd26f930fe90d9841a9639151956ee3e8f8d0bb8e20bca05f9686c"
  license "MIT"
  head "https://github.com/majd/ipatool.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b37077afc6ca201ea18cc8aa7be15c8eca35c302f3bb1d80940f7d41e047479b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a18a128291f425b1788c7f5b23d53c54d2a0af063403978e2014ed34bb7175e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "96fb896de0072556dcc27d747a64d5e5f49f8b8ce324d492d7ec73099f2069cf"
    sha256 cellar: :any,                 arm64_linux:       "63ebb0879ca00c1fc4538a4b15fa61b89b892018d8f2dab5faf9379b9c743c60"
    sha256 cellar: :any,                 x86_64_linux:      "37a32f1d8b49d571e14dad25dd92167aa0b5d13ee3cd9a704bffd5dd0d26b052"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1"
    system "go", "build", *std_go_args(ldflags: "-X github.com/majd/ipatool/v2/cmd.version=#{version}")

    generate_completions_from_executable(bin/"ipatool", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ipatool --version")

    output = shell_output("#{bin}/ipatool auth info 2>&1", 1)
    assert_match "failed to get account", output
  end
end
