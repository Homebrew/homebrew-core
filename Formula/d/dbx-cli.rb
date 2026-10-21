class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.126.tar.gz"
  sha256 "c70f751eccf45ca7ffa2a9f8d97d4d49540ff7944d5e48433a8515c08af08ae6"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6c1228aab06b22b50ed078f998765c42eca81b82a01dcc7b09537d4885dce75e"
    sha256 cellar: :any, arm64_tahoe:       "af87d43968b869733f356debe2992eb5e585a8261fd2a27d3fa4becaf72034f5"
    sha256 cellar: :any, arm64_sequoia:     "a683400615bc1f597c697f93aa96dc6ddc2e185b80a92989e0981ef60745dec5"
    sha256 cellar: :any, arm64_linux:       "e7c04eb0df4abddf5b0979052ee884b39aca3e70bab13c1f324ee19a4560f933"
    sha256 cellar: :any, x86_64_linux:      "988e9b7597958f999c1bb277e2be18fea61386dca0a890224baa2fda7811922e"
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
