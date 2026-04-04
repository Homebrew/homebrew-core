class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.44.tar.gz"
  sha256 "3622192ebee4ec8fb1d0980fd793f5c2d3c6112c1a4c594dedea56a52f5f616b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "45e38cd1f83a66e175d337afac0b40dc60ee0be58bc47733ddc22069ff843bb2"
    sha256 cellar: :any,                 arm64_sequoia: "da6dded7e73b17345accbb5cd03a78f23b3c5198e5ac8abae457e997520c249a"
    sha256 cellar: :any,                 arm64_sonoma:  "b4b20ae09f0fa49f58d808a7ccbf524563b286fe0c5ad51e406baa54dec8da55"
    sha256 cellar: :any,                 sonoma:        "0d8e2e4179e17403c211645317cace2f1da992aeab219c58668c78a60b33616e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ec229cfdea27716d8b79207ba36bb29f0f143d6b624a4eb5065ecbbec6d491f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9f0fde2c52c2d3d88e3682ef40a06aa7f2026c66508756921ac6aa270ddc2c2"
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
