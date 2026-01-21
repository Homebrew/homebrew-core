class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.15.tar.gz"
  sha256 "9af6f024e9de43692b12481f00d5c6bc430244da88aea946eeb10c3108fb693f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d4671e6495a56069953d719d6579ecc91c6a340906ab127b40698d69bd27a221"
    sha256 cellar: :any,                 arm64_sequoia: "84475d5487f8e5c96818914a2d97f36426a00397c6cab5b33632c621a0c0e7cd"
    sha256 cellar: :any,                 arm64_sonoma:  "a9bb4249bf045e0548eec812cfe716c1c1ca12fb9ff72fec0141412fdfd5e291"
    sha256 cellar: :any,                 sonoma:        "e6f9b8828f00e2fd85fdfc79cc85274bede33f764265f4c931a063ca20f7518f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02795e5d8b4a5e516e11c8a00a2abea960e3ce4e9d9055049c0d10914fa3ea3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "190ebb6c27685157504ba530b12c60d79fc656b1807db2acd7e39c82f97ecbbd"
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
