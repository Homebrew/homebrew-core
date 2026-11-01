class Cx < Formula
  desc "CLI for querying and managing Coralogix observability data"
  homepage "https://github.com/coralogix/cx-cli"
  url "https://github.com/coralogix/cx-cli/archive/refs/tags/v0.1.28.tar.gz"
  sha256 "2420450bfb7e8ded1bfe225c659dde29457691bddbf01cce5e1f91dc4c2bad39"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "199e42968c58a3a19a56111c43f791e07ec2d13a8b74e6e014971e62f54f1b80"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6d517e3aa21b46823407406ddf1e844eb9f811c62172a35b44561e44b4c4f260"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9be36cd901672e7438a70b50e96cf85932c9c2613d41a590d53755557614222e"
    sha256 cellar: :any,                 arm64_linux:       "2870b44ea453fa0e3e2bc570d508aa70eeef3a9c9a283e3ae8aae4cc62251553"
    sha256 cellar: :any,                 x86_64_linux:      "b3f577cb4e4751a3c5f3b27ef5e3172d94edc5c0016a873e8167bec38b4aecae"
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
