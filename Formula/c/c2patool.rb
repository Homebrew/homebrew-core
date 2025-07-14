class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.19.0.tar.gz"
  sha256 "4a4d4c45cb049069f00ef6cecac341881d80ef6430547050a3739ef7108f1681"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6138c93a468614800b2099ce8ceba2fd45aaf1ef9e27c62145f5b42b607f983b"
    sha256 cellar: :any,                 arm64_sonoma:  "4383a1f1da680c9565ce9305ff8a7299f59533d0b0a19e8384249668d3c21650"
    sha256 cellar: :any,                 arm64_ventura: "1106b8500f6ecb5d26b307e34c1381ad68cc5398c06b02b454af68059761274f"
    sha256 cellar: :any,                 sonoma:        "b9c16f04d9ab4ecb46b68594092ccb25d2c9662f23b1eafe22067587666b1eaf"
    sha256 cellar: :any,                 ventura:       "333efc4e9a4c9bb3998cef278403c61bd656c1b51742b6627d788923be4a962b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4670f71767a2e7ad3312fe9e279293ebe189b544b3d91a850af1e7aa14f5b037"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82d7b29fc14f14878af8d8e8b0fff6a129e5dd752f8f2764b100935f6daf3e9c"
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
