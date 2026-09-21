class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.27.22.tar.gz"
  sha256 "4f1a2823572a06debb4a1e41397d74582094c44bb6a189ebfa390aadb6264527"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6171ccf2c2929e0a89e0274740e09f8116b94d9f93513382349568de7706ae34"
    sha256 cellar: :any, arm64_tahoe:       "222ef1b13cb240703c6362ee9b5b31fa0a825bfc9265f9eeee9c10d0896bd143"
    sha256 cellar: :any, arm64_sequoia:     "256a0743049e86563941f9f9928cdd39b30bb1258fe195c79741076371f0d584"
    sha256 cellar: :any, arm64_sonoma:      "733cc110645f5142f775d71634f98f58bab932c76adee580bce2890a31f66d0e"
    sha256 cellar: :any, arm64_linux:       "d16a2994e1bf911677d67a41ca6398ca83feffb67ae77da1d897633895f99851"
    sha256 cellar: :any, x86_64_linux:      "d3c3af8bd34c88c7ea0371a99483f86193b1fdacbd2e435a3b42f0fde904d00c"
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
