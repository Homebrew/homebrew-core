class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.42.tar.gz"
  sha256 "a6e5748ef849b5ce4691d5207d0e286de45a0776b8f9446f05974d33a083da17"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f74f59eb1d04ffc36abb5e6ac9d1b5ceab1f73bdfd644e2bdbe03e8ea43530c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "face1a39d10317ad2c60cef96fdad11eb2c97b79337ed77716c5c918c80a1edb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "686e4cade2eed822a49d2ada404da2f473ab5079c3f0f0e2e735b7adae31a32e"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d3dd7d651b197aeee40526d32102f52c41965e8f22f443fab402b446533450f"
    sha256 cellar: :any,                 arm64_linux:   "f49a57431ad6f014268337241d05e9646b6515185eea111fe58bc67c4bc8cae7"
    sha256 cellar: :any,                 x86_64_linux:  "1f5d6f5d6836a9d897a0200099c47b6776ecde082ad248f3ca41e60d2ff064f7"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

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
