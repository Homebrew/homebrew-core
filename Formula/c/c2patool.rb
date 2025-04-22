class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.16.4.tar.gz"
  sha256 "0483e10f1cc103e51d874e5e99bf0a47b2583012c2096a012a48d8f2b43802ad"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9dbe846516e86d381072b8599dee36aaa51657ecc2f2e310b305e65df53f5ce9"
    sha256 cellar: :any,                 arm64_sonoma:  "0ff704da343bc2390143cc052b9241763613b6b2d90ad9e84bcdfb5266818b1f"
    sha256 cellar: :any,                 arm64_ventura: "ba8f574bda0491b163d672933752d8ea3b70ddfda50e6e58c74fc573c1183fe2"
    sha256 cellar: :any,                 sonoma:        "471bfa6d94b75c9b34b13f94f7e2f7d1315fdabead32c5eaf27a5c9e80a00090"
    sha256 cellar: :any,                 ventura:       "5fe81cce27312871f9c3398894f731e485ec2c9b7c1affff6d8f07f982acdafb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a720711769007bc7c97ed698d170deb1baa5457090a5e9339e0564aa30d32728"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ddee6accfeea889b5abfd2b4011bb14eaf1ed02425df72f446562bb5d1936a3"
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
