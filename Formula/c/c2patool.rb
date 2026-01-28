class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.19.tar.gz"
  sha256 "212925d62643da953289a87ba97cee6657f7cd657e3868cd2a012fcc0572baef"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b1375c2f22dbe76accd6eb3c3464e659abaed566dff9f79b601842654184a2ec"
    sha256 cellar: :any,                 arm64_sequoia: "136bf350afa6fe51c01876fa8d1982d737afa2cb0e166b47ae60224d6bcf2b67"
    sha256 cellar: :any,                 arm64_sonoma:  "608cff8920f403686cb1c763bfb1492bc43a29b648c36367a0d667c1b4043e4e"
    sha256 cellar: :any,                 sonoma:        "88fbd3766cb9e54a906b6574b46698c162f99dba62b169dd99a755eb1146b335"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "948ed7f2928324061bde20e1c25538b53713ec4e95888661d87d4a77882a2ebe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "946838ed98f6d3f22580cece61b900d45d9e61945620a9409fff8d71b9a91c90"
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
