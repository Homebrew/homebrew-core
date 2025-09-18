class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.22.1.tar.gz"
  sha256 "72187ec36137e9d818417f1e8b318885611843a4defb935b5824d8b259278183"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3926786a22a73e4382dc13bf22c05e09e4517e54b38498ceab06129c27d2ba18"
    sha256 cellar: :any,                 arm64_sequoia: "eece8dff5fe991e9813881df8095c3725cf131b762c208b2f29e55bbd4a71f43"
    sha256 cellar: :any,                 arm64_sonoma:  "8e037d80e2cbf770cfb77a17c41a9f97841eddc0ebd0de0c95fd03fc1c7edad2"
    sha256 cellar: :any,                 sonoma:        "e49fd55172f68ad996196d5e91dba17041bf2f0d9cbfcabe9f1bccfbad73ee90"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44db1ef27643be36f0e3bafb6c6acd8f2ac828177ddec85268257032763b57fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2bd2da638befc86f0e312fcd75c1976db01da1dc07cd76a709d2fce22effb4d"
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
