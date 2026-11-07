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
    sha256 cellar: :any, arm64_golden_gate: "b4098e79e9782a720bf1aedff1a9a354ddfcbe1bfe706575886f5a1a2acf1df8"
    sha256 cellar: :any, arm64_tahoe:       "a10f27b9d43b7a51aecb38cf2ee7861ee5aa7bed738369d3322ea33eb0288fd0"
    sha256 cellar: :any, arm64_sequoia:     "05df91a166f0ea6a68ef1591d390a292b14e5264d75b8a113524b5d54f2578e3"
    sha256 cellar: :any, arm64_linux:       "7cdc88ac040716b6fbfbc4bb10f38c8e8082158963249405ef491aeca4616d71"
    sha256 cellar: :any, x86_64_linux:      "dad20444c9bcf69eff980f4383fd0bb0614f13dad6215baf98b401852efb8168"
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
