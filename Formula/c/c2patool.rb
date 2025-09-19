class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.23.0.tar.gz"
  sha256 "964c2b7a988bd7020be050c96d0fcd99be0275855d027d32efab66da6b93a518"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "14e2f585066f62dfc6dade90045f13ac8b94d4bca266b824138d194121a44438"
    sha256 cellar: :any,                 arm64_sequoia: "ec14e6958bf278b3cba78f33a4418ca2ed3afa436a47e7130d333078932d4cbb"
    sha256 cellar: :any,                 arm64_sonoma:  "8fefd5a0e281099b0b4878f5e5c84024148f87c5dfc20277979e42085baed21a"
    sha256 cellar: :any,                 sonoma:        "46e4caf33628e0efe14bf055331485dfd847445970eff726e8edf872f0276ca0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78fc098fe93a086ac1545112e12e9fde7084ddc32eee4fb84026c321cc288103"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62282bb848d5abe21c04d2f228d18a47cf20c142325b8eb13e6c98e59dc4064f"
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
