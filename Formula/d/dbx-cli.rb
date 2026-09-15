class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.87.tar.gz"
  sha256 "b98d43b8bc05169997dc3ec6f652b9023ffc36767c00ebbd609b25988b89afe2"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "dcd8ed298a567d7850ec27d91dea8c56848aab0363ebc5d19c0ba0214f1fc229"
    sha256 cellar: :any, arm64_tahoe:       "53ec1301c7e2dff53be5e2255b65b6b1e48ed055b8f86c67ff58ac5f62711f7a"
    sha256 cellar: :any, arm64_sequoia:     "7ecd6a1a73a0d6d2c0384179bd8db18750257c4b929fd1b07343a9585dd9dd21"
    sha256 cellar: :any, arm64_linux:       "26f333a8d5d96917a0e40c813d2dc4a93b384c541c156c3cc57592d77d35feb5"
    sha256 cellar: :any, x86_64_linux:      "c41dcd02f7406f33594ead6e1b70a66f24ce8d1ac47ff3446088fbceeb9284b8"
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
