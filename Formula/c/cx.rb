class Cx < Formula
  desc "CLI for querying and managing Coralogix observability data"
  homepage "https://github.com/coralogix/cx-cli"
  url "https://github.com/coralogix/cx-cli/archive/refs/tags/v0.1.37.tar.gz"
  sha256 "759d1d7bd971bb850053dd13e59e9076b8f193ded2569c72338a378dd89bc29b"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "6103c49de60f556e5add7194a2c11a32c2b3d41e1fa7db3e7e375861058dab60"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b08c9a2c1c7a628bcb5ddcccb339280125df9a23a496a75f93ecd192c1931c8a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e40d387f7a6ab43f15fff619fc67dd85e906af8ec1c3ff6d94933a8da7f763dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e1f88d4d15a16829136b571c7799064fb52b3807185b684c9eee15c9c8816488"
    sha256 cellar: :any,                 arm64_linux:       "3d9dab27b2a6f3a63f517ce7bf36ef08dd53c44f45acdf3f252baf18388cec91"
    sha256 cellar: :any,                 x86_64_linux:      "bbcd038f9391abcc8a5814688be5044a8f91141e979c335ce37d09bfe7737ea2"
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
