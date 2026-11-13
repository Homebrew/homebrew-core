class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://github.com/contentauth/c2patool/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "e63fd122be91ea8c8cc99caa1471e86f06efa59d0e0e3e0ebb6f19483a1e977d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2patool.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "3ada3a08d069ba5ff8b796df6d8a7b27ed3b8c780205f0a70ddfb43ac11922ca"
    sha256 cellar: :any, arm64_tahoe:       "81350fe7d0a46ed232cd5ba08a509c70b3f171df37266888cc24bea7f8dc0689"
    sha256 cellar: :any, arm64_sequoia:     "87489f10ad97e28fc444b2d2b39c141d1ac44bd1eb038c154300a2c7156d5dd7"
    sha256 cellar: :any, arm64_linux:       "486e0c17e78cdec0bf876f6f7877dcb193d70b8ce6a11382c5de11ab8248820e"
    sha256 cellar: :any, x86_64_linux:      "0a3f2d59a249c5c3524b1b64691a325307512868efd3978af1c308c464156b49"
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
