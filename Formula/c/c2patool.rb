class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.23.4.tar.gz"
  sha256 "fc68a916cd9e4d69cf91f51349ea711773c9689e28e7a9d029f54b5ff03a174b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8722bad5997f234d11f5c37a0a9e508857b6cb9b0b41e94e2b94c3eaafeb3cd7"
    sha256 cellar: :any,                 arm64_sequoia: "bfa0c8d2bfea87cac092c3ba1192cbd61da2bf307d302849e85e39646fdaf8f3"
    sha256 cellar: :any,                 arm64_sonoma:  "a8cf8886be73579b9036d73b7194b036a0d3bc18c76ce3b7e3ada12b0660183f"
    sha256 cellar: :any,                 sonoma:        "1dd0969b1899cf6155c4e3702bc21fc262c89bf0728e2502bf1052d00d99a9c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1709bdb01e7204aad9bf71a0b1bfebe4f9d1c811d541b71da28215941272b04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cd751d40da5f0e4dd7a5f9299934b15f03cdd34f9576a34087d96a30417e270"
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
