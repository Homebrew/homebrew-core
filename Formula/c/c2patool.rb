class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.59.tar.gz"
  sha256 "44155040518661416520d2727bde386a4dc44ead101baddfc9debeb726c40796"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a193b4464c74eb43975611b176cf4f1b5ca0ef6cae70149d203148f787933731"
    sha256 cellar: :any,                 arm64_sequoia: "385a47a382a45d21e30055cca2ca647862daac65dbdcd750f928c34f937e01bc"
    sha256 cellar: :any,                 arm64_sonoma:  "f6f5818d1dd25052b1904f8e48cd24386ffeb15b3b220e1e93dc7e273d4c54fe"
    sha256 cellar: :any,                 sonoma:        "10c51e0450a9f294295664b2bf47dcf704689c685ac7452fd6fb9f80c2815c4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4529dae92f9703c920d9313758aef2d5fd4f526b49dedb307f7ddd9c42566155"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "386a1c7f046492f88186c1d001ee775c4a1449a6ded7d9a80b5a4e031041bc7e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@4"].opt_prefix
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
