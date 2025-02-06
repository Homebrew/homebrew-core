class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.13.1.tar.gz"
  sha256 "ea1fce5e6e5c998234a33bbaecd8b50445f14a29e1635483950f36860a75b39c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6b75ab55d34bbd970fd600e6f1fc430a94539173b4b9b1e58e5b36df6f06eb5e"
    sha256 cellar: :any,                 arm64_sonoma:  "3489d936ba36fb8537a693186ee8e2f50e19009abce7f94793b4c8627e82da22"
    sha256 cellar: :any,                 arm64_ventura: "9edc343cb37d52ed08b24d21a83d46537187e3e0670c4f6ccf2ece6b6bb1a62d"
    sha256 cellar: :any,                 sonoma:        "266c84052a3b96374f39be0a6d97b8d89f2c771e35a34674d852f631905d4b9c"
    sha256 cellar: :any,                 ventura:       "ed43b001b832bd157b724633dc4a0bd3a47571b6bee4ae27e37bf294ae35a5dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b32ffbb1560b6f8e0d8a6a6179d93a2371e66b5b933ec18f1dd445cc6375687a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "openssl@3"

  def install
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
