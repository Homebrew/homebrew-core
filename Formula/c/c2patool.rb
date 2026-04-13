class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.47.tar.gz"
  sha256 "fc501da791f9b85eb9a5ad7950f9c231a8f16d87ad98fed67aac4f9750777f88"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a0c1ef78a7388cb22afb8f1ff074bf2e9aa158cf61cfd3ae95fd79f85748fb1d"
    sha256 cellar: :any,                 arm64_sequoia: "a13cf7c9e53003faf97cb7fdc42106852b48ecf3eb5965b376304dc5c2c3adb4"
    sha256 cellar: :any,                 arm64_sonoma:  "ae4bd79ace796f0b2e840e71a9fb299a4b98a2688b5fab69f9b8a6c3bce1b8a9"
    sha256 cellar: :any,                 sonoma:        "02912d20b25dd1a548318ef13d1f2f0af575601076a9d3e0216504fafffa631e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53597b48c4d2a2770b0eaa6ea9859986019255b1726d43ce44c1757d4319e32e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "977d8b84d533116c9ec851e8b43fc3f47e4cd73fadce1b8cf008d99a047c9d99"
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
