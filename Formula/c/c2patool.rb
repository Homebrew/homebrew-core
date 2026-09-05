class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.27.20.tar.gz"
  sha256 "5e05255ad8625467cf2cacc8b155938a7b40b596eb50326773d925864566d418"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "59290e82dbad6d0ec023c537b99d19c3e4f98a5cd0aeb1e89eeb5e36dc1094c6"
    sha256 cellar: :any, arm64_sequoia: "890e14b29d6f79beeffc709db7caa699419ac4785d88656775d187a749421496"
    sha256 cellar: :any, arm64_sonoma:  "a2c67605051a3e073d2fae2e38733c7a432565e2f15295b701c9ca84f43c5b27"
    sha256 cellar: :any, arm64_linux:   "a2dbc6479a0a35cbeb4cdccc1f3722fb830d49adc4c5cf0e4446032a36adc588"
    sha256 cellar: :any, x86_64_linux:  "ec9c444fc58394f302431c6447d151354df0b6f27da5651b19ba5aee61e6af22"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")
    system "cargo", "install", *std_cargo_args(path: "cli")
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
