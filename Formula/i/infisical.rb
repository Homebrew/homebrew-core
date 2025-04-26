class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/infisical/archive/refs/tags/infisical-cli/v0.40.2.tar.gz"
  sha256 "b2a04b4afa74170aaaed46fc0e218bf23663c656e990a8424fa85904d27f269a"
  license "MIT"
  head "https://github.com/Infisical/infisical.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^infisical-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a208f196fc770694e8979c2405c32f0a84e8f9928edf5f5c94a8e1d9b8e4990f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a208f196fc770694e8979c2405c32f0a84e8f9928edf5f5c94a8e1d9b8e4990f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a208f196fc770694e8979c2405c32f0a84e8f9928edf5f5c94a8e1d9b8e4990f"
    sha256 cellar: :any_skip_relocation, sonoma:        "12028c34673eb0e44fbb03a43a27884a6b6965dd7eb1dc551d471ad73570bb15"
    sha256 cellar: :any_skip_relocation, ventura:       "12028c34673eb0e44fbb03a43a27884a6b6965dd7eb1dc551d471ad73570bb15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "820176be5d9a70299da42d62c13681f65b62ee67c06a64f5f90716aa853cef76"
  end

  depends_on "go" => :build

  def install
    cd "cli" do
      ldflags = %W[
        -s -w
        -X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}
      ]
      system "go", "build", *std_go_args(ldflags:)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/infisical --version")

    output = shell_output("#{bin}/infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}/infisical init 2>&1", 1)
    assert_match "You must be logged in to run this command.", output
  end
end
