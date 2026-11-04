class Cx < Formula
  desc "CLI for querying and managing Coralogix observability data"
  homepage "https://github.com/coralogix/cx-cli"
  url "https://github.com/coralogix/cx-cli/archive/refs/tags/v0.1.30.tar.gz"
  sha256 "099c7a4ed64264f8cd900c243392e305c0071f208dcc8d4b90584840205f7bfb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "930a408196585cf9bae7390bb03e2c2366c47f0420230226f60ed8f594a284e2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "eeddd11e834a98ab2de1aa9ef427d33674ff010166222867ff739d40c77e8edf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e278d9b6907effbdf4c4f1dae638a8869a03b230cbb3682459b4d028d0c38c32"
    sha256 cellar: :any,                 arm64_linux:       "0a98287e8ba984da8e85bb15a2f95af7ffdd3c67a1e4d70a4a334057d259f2dd"
    sha256 cellar: :any,                 x86_64_linux:      "aea7c3772008c4ba25c01d391085dc3c3b9fbd83afa5eeaa3a67df4f62e9e443"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "dbus"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["CX_NO_UPDATE_NOTIFIER"] = "1"
    assert_match version.to_s, shell_output("#{bin}/cx --version")

    schema = JSON.parse(shell_output("#{bin}/cx schema"))
    assert_equal "cx", schema["name"]
  end
end
