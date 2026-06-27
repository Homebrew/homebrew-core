class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.68.tar.gz"
  sha256 "e306b46366ec48489d517819c760bd38e70e41eb9d859b84e018a8a4d51c6568"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3981011be6b7bcb0b625695ca12086d43e74f6aa9b2d1dc3d1bdfa20ff30d3ef"
    sha256 cellar: :any, arm64_sequoia: "e382b0c2dedc5aa7f23650de910115edeeb2cee4dbfeaec02dd347306305d8a2"
    sha256 cellar: :any, arm64_sonoma:  "20314dd1c3efc46cadce7cf01fadb91226a9b55fa9b9d6018245fd3858224363"
    sha256 cellar: :any, sonoma:        "a30343b8ae1ab5e277a256ddd08d5d483fda0f930b603f900afd12fb1c0ff232"
    sha256 cellar: :any, arm64_linux:   "6689b19c279aa65d6cb700c6e6720ad251268959b2aa377ce0fd9345870dc963"
    sha256 cellar: :any, x86_64_linux:  "e495e856aefe39dbc4a96208070ebc8f99cdd8fcd3ee783695e88bc40ffb116d"
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
