class Cx < Formula
  desc "CLI for querying and managing Coralogix observability data"
  homepage "https://github.com/coralogix/cx-cli"
  url "https://github.com/coralogix/cx-cli/archive/refs/tags/v0.1.37.tar.gz"
  sha256 "759d1d7bd971bb850053dd13e59e9076b8f193ded2569c72338a378dd89bc29b"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "5a5beb186f02e6df8f5be6bf10a7907d267a2acf152be88a3e75f68718cc585f"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "92b7e7d9a3630f68ba4a91e6a47ecc1824f4cd8d75297a2488157c395e609693"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "239ad1fcc5494184e5a647a0d253429ad9842337cb38676631ff12b714f91566"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d96a5c8afa9dd14619eaab8d4fd7b450d4e22a10b86968de01efc8bfb4efde53"
    sha256 cellar: :any,                 arm64_linux:       "1b617334c0c2edd8834fcb4a6ba7f9125368570c3762c6fa005c743d80964dfb"
    sha256 cellar: :any,                 x86_64_linux:      "468ed043d15a57eac75e7bbae6b89a33bde149b7abd266b52a19a9637f7938e6"
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
