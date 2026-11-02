class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.137.tar.gz"
  sha256 "894b2714af4b008cff38bfbe97ee8fd2bb8c1f8ff032124cbc5e45902cfecb73"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5bc53fcf75d2144453ffcc0a8218dd34b56c0456dfd8a639309d12729ab433b5"
    sha256 cellar: :any, arm64_tahoe:       "f7d6c678553d7fae26e7fbe83d0ecadd23a5e73929220e94bc34ba8a6c3023fe"
    sha256 cellar: :any, arm64_sequoia:     "40eadf3a1602cdb80ac8e22f1596e5b0a09f8715b1abf6a9b3a4088acce2fb77"
    sha256 cellar: :any, arm64_linux:       "9286628778b6f5b182278f4f81f61fef07395f10da14b9ed4195cdbe2c7c3450"
    sha256 cellar: :any, x86_64_linux:      "19cac917b1aa75b43319d5661e63cea20519da347a199683b9a38268195ca787"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "fontconfig"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/dbx-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dbx --version")

    output = shell_output("#{bin}/dbx capabilities --json")
    capabilities = JSON.parse(output)
    assert capabilities.key?("directQueryTypes"), "Missing directQueryTypes"
    assert capabilities.key?("bridgeRequiredTypes"), "Missing bridgeRequiredTypes"
    assert capabilities["directQueryTypes"].is_a?(Array), "directQueryTypes should be an array"
  end
end
