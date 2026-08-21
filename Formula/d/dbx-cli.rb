class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.69.tar.gz"
  sha256 "5a974aa1b9955c21107edff39f497685b6d9abf5d737676ed9fdec856e6656a6"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6a208926e5b664d72cef152254e53c91099b35f8809b8d59139a9815917b1b8e"
    sha256 cellar: :any, arm64_sequoia: "1a8db9d6f1ea895fd2775f3a3ddbe9497e0aef318eb7b81b8d192f1b8e7e7c59"
    sha256 cellar: :any, arm64_sonoma:  "7c2d2f9df7a4f8316ec3f208de29f4cd74831cbdd1b08ad12b3af7f9d6f53152"
    sha256 cellar: :any, sonoma:        "140d0154bd3e8ac1794f68a1e39756fce9d9eab9ede67507d177a019a911b8d1"
    sha256 cellar: :any, arm64_linux:   "cfbe5da741690f6bc84248bf83fd8a52ff0fa196e64347a92ccae15df6cfbda1"
    sha256 cellar: :any, x86_64_linux:  "f94fc6893276e418a31fe228caf479887474df4fab84c48336b14c4222c88281"
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
