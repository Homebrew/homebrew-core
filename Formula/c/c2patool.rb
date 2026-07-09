class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.69.tar.gz"
  sha256 "c20732f9f2b08b9f6b3ca00230133832759b849b3649b7a2e54563f2bf7251ff"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "cf9b9c64ee600efc6c5a8b83f522943163e774a4a804f2a991e0573b2aefce83"
    sha256 cellar: :any, arm64_sequoia: "c59b9f3e11bfe89e3ea2187f90a4860b444b994896a95265fab4176338c15ac8"
    sha256 cellar: :any, arm64_sonoma:  "db7ace58610738609ac91aeba5b3e5108cac16d344db84a835158deaf2585077"
    sha256 cellar: :any, sonoma:        "b56eca95de807cef653f573a84edac7766dc5a34d84e872c09903381f31914eb"
    sha256 cellar: :any, arm64_linux:   "b4de63ec01152ad35de5dbbffcc5c02b763b2165e5c71ae0ac278c10dd65dc9e"
    sha256 cellar: :any, x86_64_linux:  "2ea54effd8a90bdadb371716c025bcf842a541379453dcefd7a769ba75f053ba"
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
