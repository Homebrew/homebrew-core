class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.20.4.tar.gz"
  sha256 "3700cc3de2ba10fccd2465825cd8156d969cab32f2d1e191e799294423e3cd0b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "aa727bf639ea6ce63834cb2a2a4d63d822d00d43d8f41ceaba7f4970189ab337"
    sha256 cellar: :any,                 arm64_sonoma:  "f30990372aa31ae5ff02018135f9a3d5f57c9bae424c7d702d93a809cb7d44ef"
    sha256 cellar: :any,                 arm64_ventura: "7be583fa4adb7b8ee0970f5863e47d6bd1eb8fa584dade5c74a9ec4b242a65f4"
    sha256 cellar: :any,                 sonoma:        "bf64a4c76b8069ca1eba005252f6d909c9aa47dffc24e084fa0460d60882756e"
    sha256 cellar: :any,                 ventura:       "87da3026604c358767053925eaafe9b4513fc6543da55e413c1d3a968ed64349"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8bce40faa71acc10812bb704469a360d82a7e02c28a06b6e61ed088417669a2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12c0d4a00d36a3d54e540ddda385918005732957a2aeab4f199e40d198c9b7be"
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
