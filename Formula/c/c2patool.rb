class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.27.15.tar.gz"
  sha256 "0a02eca6f34b46db6ce499705a68ab0da0feb172f5c6600bca2daa872c9c494b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a8a886f6308bb9aacfd1373a54ddaf4a5a5987ea6a81a653b4eed716d57407dd"
    sha256 cellar: :any, arm64_sequoia: "d67ed62fee4f516a8ce06fa1b656462941d8172f46e1dc47984f1ec6deb0cb9b"
    sha256 cellar: :any, arm64_sonoma:  "ab353114686a77ed238942265cdf2e97ffd68dc968889633e2b6faf82008cce4"
    sha256 cellar: :any, sonoma:        "0d2567b840bf58e8d6a0162192100017719218ec17fe5a9e97288c331b27c78c"
    sha256 cellar: :any, arm64_linux:   "887871ccdd30882be092b9898f8e83dd86badb04a6239ddd6213d159b5808090"
    sha256 cellar: :any, x86_64_linux:  "723e11e1353dcb7b8891cc08e17acd714192e4e91c12b8f424ae45b66dc4fc39"
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
