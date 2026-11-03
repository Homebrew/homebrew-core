class Cx < Formula
  desc "CLI for querying and managing Coralogix observability data"
  homepage "https://github.com/coralogix/cx-cli"
  url "https://github.com/coralogix/cx-cli/archive/refs/tags/v0.1.29.tar.gz"
  sha256 "378f3b04506e172ee17e39322373a9d363771af27c4bcc14887e9f86fee4458a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7ea06dfce89d8fd73cf88ef725d9b57d5d1c1319047bafecf9d7f66ba7d41be7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "20773228085393a151404dfb0f677fc736f9f9a955cd3124df6d6a4a97e4e52a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fd0e2a87b81f86ed2676e2b03aec923532df49e6cd707de7e86ab23628343a98"
    sha256 cellar: :any,                 arm64_linux:       "99dcf7eaeda24ca330fbe2642a5ccf006d5f7263c7db8950fcc1a3e33d75d733"
    sha256 cellar: :any,                 x86_64_linux:      "439613677ec0db6c245216bc6c66ff36e794164c1ccdf0f5d31d82f1571db620"
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
