class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.80.tar.gz"
  sha256 "5cac0e9ed42f9c57d3474ee03a39676e5fd0e7f5f5f41eac85774c9172036a9c"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "12a10916a1c6fb9ab2d44a1ad3516353527043db7056167095c6325445970a9f"
    sha256 cellar: :any, arm64_sequoia: "48175a517a3f4064b201c54e661763a8a8fa57c176767b49c1ed885da9e606b7"
    sha256 cellar: :any, arm64_sonoma:  "a45017075b4427be4bacbfbb08b9ddf1f778c8dac57fa1a9b42a249000de3668"
    sha256 cellar: :any, arm64_linux:   "e076f9c58040d27f3c10a3e1c30d4907bf1a9365e2cb5f991b78bd6005fcf44d"
    sha256 cellar: :any, x86_64_linux:  "778d28818b75d141ee8ca1187843d08899057403aea4454ecc72ed32386726fe"
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
