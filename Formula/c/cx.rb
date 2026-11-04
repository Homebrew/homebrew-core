class Cx < Formula
  desc "CLI for querying and managing Coralogix observability data"
  homepage "https://github.com/coralogix/cx-cli"
  url "https://github.com/coralogix/cx-cli/archive/refs/tags/v0.1.31.tar.gz"
  sha256 "f217ae62ba6eb7703f5f69fce06f774b2ccf5d46f6eed0240f6f978f49257dd6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ec2866e3cf1b8963533977df6b8bb220ada52c86052d6b80f7c292a11de3638d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ac4c37cc582a1d0b0e2a68c3d293f2a631d31f67c392323005c7ac09ed8fd28a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bb3905773ce387986422e43f7b7651b1986ca5bb77570de2c7c66fc4156e45dc"
    sha256 cellar: :any,                 arm64_linux:       "c8bf6e1fb431548dd0dafc1c1e812505fc22dc03ea06163c2cd436b4cc2c2bb8"
    sha256 cellar: :any,                 x86_64_linux:      "9d63df1790f49736647720764f3b5764cea4c7a26989d2f01c4d6906c6416d94"
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
