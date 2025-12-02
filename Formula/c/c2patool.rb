class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.5.tar.gz"
  sha256 "de47fe8cbb58a733d97ade1d36e1a46f066cd6b30a3b1637f5671beadbb3a39a"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8d7c92aa2bda0088b383d4a6de85c80e70bc093a91c46d6117da79d2fc917666"
    sha256 cellar: :any,                 arm64_sequoia: "e120c87dd3f745a2a2427780f752b2f188696a15bbe6965a9eadbf83990845a3"
    sha256 cellar: :any,                 arm64_sonoma:  "424b15574a0cfbf90d99b0eebaf47c891475d43770d2274011f93e0e58bb7b09"
    sha256 cellar: :any,                 sonoma:        "067a379d8d3cbd0cc4bd561f36eace5137c3f1b5b6adcdb4898e92d8f91e62ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "367657681cf83c4751ecb2206c890635a0a7af82ab8567e349494e97c31fa01c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06f869462fc0e1d2f16a94aa6ede85f2464c889fbf78763480966873ee4ce9e0"
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
