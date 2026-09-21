class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.92.tar.gz"
  sha256 "9963d1145e7d101066b1633c2f69d3e30415e33c0df970fbc43688326b13e2df"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5c665dfd2dd5c5eed07c901836b65c99d45a2689462f50c21a95369a57f69ed6"
    sha256 cellar: :any, arm64_tahoe:       "c892749580196a21213728235abe78cf0e1623bd04aae7b286121d29d817cca7"
    sha256 cellar: :any, arm64_sequoia:     "84c099cd0b20fce5399d985685546d26a6a9615106d396f701883a1cc363f3db"
    sha256 cellar: :any, arm64_linux:       "2a975a17429db268c8db5f4ea4ab9b7897e5bb297188cceb0bc67bb2c8923df2"
    sha256 cellar: :any, x86_64_linux:      "32c3605db4434000fa610d80da509a6ee2f2b01c7d8334c547e492de3c98c5ce"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "fontconfig"
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
