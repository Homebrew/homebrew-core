class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.16.3.tar.gz"
  sha256 "2598f89077409911a6a1c433f0ec77f46f5adb6621edbd2f9e02d7db055e77ec"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f2cefb0b7ea3de892bdfa09eb7aab06e80fdaacca538eeb34d13352172ed1876"
    sha256 cellar: :any,                 arm64_sonoma:  "9031dfa51e8ed86ab79977fbcbc7ef676abeab12792d73a87ec65dd9d7776d43"
    sha256 cellar: :any,                 arm64_ventura: "ee7482061b152db69da08b9df4da7a00977450a86029429e3026c725fa050b23"
    sha256 cellar: :any,                 sonoma:        "69b55c8f8fdb35acc162d6192d15bf867263038d9882203cdcef684700f58117"
    sha256 cellar: :any,                 ventura:       "31932ee984ddec00bdc0c5046ce51051e4b66db5a085dc9768abe651671e8fa3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d452ef2d7df0f86476ae9341de5c5a28742531599598a7f569fdd98ad1fa062c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "154c99361ddec54d578739f93327a16107f98bc5481589e9cdd95f9c3c2f2b96"
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
