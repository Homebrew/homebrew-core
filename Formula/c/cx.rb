class Cx < Formula
  desc "CLI for querying and managing Coralogix observability data"
  homepage "https://github.com/coralogix/cx-cli"
  url "https://github.com/coralogix/cx-cli/archive/refs/tags/v0.1.33.tar.gz"
  sha256 "4b4e88c2208806d545eccb5a5abc72b1ca9e3f0f585613c984fe23c4d7d6b212"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7cf51ee6d6ccffa56540e95eea3af11ecabaed2fd5d62cafc6a889248e7f7b1a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5cedbece4ad42547bc4270ee532f90d9743df83c3b5ed88afc402fdb7e6169e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7cf6d85ed14c5151b6236f63d39e00bfe7e746cca02e9ecbfbbbb0857e351f46"
    sha256 cellar: :any,                 arm64_linux:       "7d32544274f1385a60e89c343aea3d5831b7ae72491681d6d56eaacfdd1ffdec"
    sha256 cellar: :any,                 x86_64_linux:      "c9a955478ae8e665328cdbf77294a2329ab193910f5239bda964248ca20da407"
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
