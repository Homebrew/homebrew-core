class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.71.tar.gz"
  sha256 "47a3f72ebee6bda64fe1345289b27590801f1c316f40c5843ec8adce3ee4bae4"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "77676d7a2904d9dfb0d49cc7deca7c5c6a67e4c06d2f19eb6387cc8383875acd"
    sha256 cellar: :any, arm64_sequoia: "72e5ddfb3a20a8d0385ff45e97920fa9fd24924d4e2195fd6c1910339593257f"
    sha256 cellar: :any, arm64_sonoma:  "45f5b78ea4d764313d433d820b4cb6e8e5989f1a145184b5b8d590304c5a789f"
    sha256 cellar: :any, sonoma:        "8c23e56ed42ee90923528b2a36c8383cc7f33d36c3c682a6ddda854f646e3083"
    sha256 cellar: :any, arm64_linux:   "9099a204f38c6914380256a33c6405ea324efa28d1b9e2ec64cd7ea65f671a40"
    sha256 cellar: :any, x86_64_linux:  "92626215033b3066446eaeb18efcb47025c41812d812ade0fa5b9a99ddfcd93f"
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
