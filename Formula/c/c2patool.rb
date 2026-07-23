class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.27.1.tar.gz"
  sha256 "5ed90232fce87b24c1e6de055e7449a7a9c21a91018ccd48f2bce7fd191b64af"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4e79d9f1a060b5ddcafe9559d44ab123367238af5d764f6ab9815738b4f12c27"
    sha256 cellar: :any, arm64_sequoia: "e17bcaaa0247dcc9f180e511db179284795e4f37cebf904e2d19423729806308"
    sha256 cellar: :any, arm64_sonoma:  "1ef22b0f7bafddded611ae4b0e6f987d94e18599fbafe7dc7ebf2a02c97279ef"
    sha256 cellar: :any, sonoma:        "a842c9065ef455470ec4a7f4e467c5f7c04a79cc9c81d17809e93b27bf57422d"
    sha256 cellar: :any, arm64_linux:   "a9a1aa596b5d29bec693331d8b01a0e4b517678860c66cca60ae73f0e84853bc"
    sha256 cellar: :any, x86_64_linux:  "ad0dbb76db6a71dba436776647668301f240b0a30e0a7d1c577261523fabdad4"
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
