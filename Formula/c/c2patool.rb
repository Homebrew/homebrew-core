class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://github.com/contentauth/c2patool/archive/refs/tags/v0.28.6.tar.gz"
  sha256 "df68d7e5ab35a1b120a1c6cdbcf00129e05dad9aa73b49feec33a8a5aa5aef3c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2patool.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6a605d8788d7402dc88b672bb7631dd868f1f91de98d2336077d1ad564e21bc8"
    sha256 cellar: :any, arm64_tahoe:       "09bc2aa4c8a75a106a31df19a724d6c039fff72e9ada070e73b7a58af2647e87"
    sha256 cellar: :any, arm64_sequoia:     "42e7ff50d9e86041c6ff83a9d8962769c768519b88c68c494bd96a85cdaeee2c"
    sha256 cellar: :any, arm64_linux:       "9d4310c3c5ac480b625291c5625c5c3913808106a6205489ba5d9a4b354d45c9"
    sha256 cellar: :any, x86_64_linux:      "d582fc428cc721371393950f111591ec5ad1e2a4c2c3c4d3d402dcf19d3c8079"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/c2patool -V").strip

    (testpath/"test.json").write <<~JSON
      {
        "assertions": [
          {
            "label": "com.example.test",
            "data": {
              "my_key": "my_value"
            }
          }
        ]
      }
    JSON

    system bin/"c2patool", test_fixtures("test.png"), "-m", "test.json", "-o", "signed.png", "--force"

    output = shell_output("#{bin}/c2patool signed.png")
    assert_match "\"issuer\": \"C2PA Test Signing Cert\"", output
  end
end
