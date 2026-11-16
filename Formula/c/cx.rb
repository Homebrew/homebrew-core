class Cx < Formula
  desc "CLI for querying and managing Coralogix observability data"
  homepage "https://github.com/coralogix/cx-cli"
  url "https://github.com/coralogix/cx-cli/archive/refs/tags/v0.1.34.tar.gz"
  sha256 "1fedcb9f723893c85222fbb2681e83c638b78a1d2999fb28258471b0987bfd1b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dcc41b34e7a966ba0fa24bbf3b0817ed0918237eacced8ca9981385e73c2e851"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5e678b6786d1d0abf513e78f45263e2b3e722239d2296f63dfd840b4159d5efb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d116f03337613c3a4d710b1f53e46efc349e1c4843ce4dba1224e846bb5afee8"
    sha256 cellar: :any,                 arm64_linux:       "907549d8b7a6a8ac0b85ed8a047aba8794a93f9d417fed5001c3dc072cb3d5b8"
    sha256 cellar: :any,                 x86_64_linux:      "fba7f4b9227101956e73399f5dad6ad9944d60a5a2d86f0b1759848b788b8166"
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
