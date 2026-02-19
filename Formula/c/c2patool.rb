class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.29.tar.gz"
  sha256 "f5b546eb86ab5f71d91dd7569119d0b71db50156c4bbe326231a57bbe339db0d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "37064c4bff012995425195ff545c8ce5188508645821b677bc23c88e230aceca"
    sha256 cellar: :any,                 arm64_sequoia: "e7660414ea80ce814ef72bf084742e5b465520df35f36cc9ca0f8b0bb95978ee"
    sha256 cellar: :any,                 arm64_sonoma:  "69ff6974e5cb267519abcf91f56cce5b066538194e1bb3ac8bdd8b9150fbc531"
    sha256 cellar: :any,                 sonoma:        "d1aa7964031bde66de3e2bdd19681e16866c877395e77806626da0ba4d37badb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "543066592c64b8f1337e785d9faa0ef236d184b23a5ffb0097a6cd7c47a299c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77cfd32867798bfc0961474bd2df77c7191150cc4225c250adb66c43ada433d0"
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
