class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.50.tar.gz"
  sha256 "4d4cd5a93e39b7e589967bda9dd460014c6d6632e1e0043bd7fa957516e007e4"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8614ee7d262d19d09760b6329340f876b914008e4ef2b03c7a3c84522211ed07"
    sha256 cellar: :any,                 arm64_sequoia: "0917844fb262f872c1568937905528d521755a36398d072f9b09aca2b8880425"
    sha256 cellar: :any,                 arm64_sonoma:  "4ede5201f724bf89cae4f14963eee6200d174c0dc225597ac3586f3e6787fa13"
    sha256 cellar: :any,                 sonoma:        "19288f6c7c96cb94c616fcf15f370f6eaf56cd77b880df617a0cc228437c24d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "abc2882317f3dc755fe452bf6971a0db3479edf3fd0a9ae5dcecc963e22acf69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d01b7b8483867844e030c18a962c3226dffb3f4fc2899314e89b88990d7c8ce8"
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
