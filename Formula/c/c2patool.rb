class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.56.tar.gz"
  sha256 "8a4b4cdcc303ac5818a57377a1625ed4e4d6d383618965fdfa06c76b632808b9"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "67c2b8cbec227861f72665cb9d80c3377a502c900e33c8316b59c21c3dbb3b33"
    sha256 cellar: :any,                 arm64_sequoia: "de144947286b6762b56a4ce517189b2439d64b43fc42b7c4ff2a90c83b2d460f"
    sha256 cellar: :any,                 arm64_sonoma:  "ba93acb35e2ea8ba12c295414eb77150503b718663945af791b2f623da070f96"
    sha256 cellar: :any,                 sonoma:        "53c994609226e17e23f8779fa7483cd1a2a4dd12ab782c971260c8aef1ade5e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad24c205e04bc95882673748f1de468f31730be2ebb3ede5a7cc265b1d782672"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ca1d75d071ea57367d4afce976d8de6ed871948fd793cd52268fc20213831de"
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
