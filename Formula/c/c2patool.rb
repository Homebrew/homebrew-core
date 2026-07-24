class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.27.3.tar.gz"
  sha256 "32cc2babbf296427f92bbd61dce5c436460e0e09eb00782fbfbda62fd82c00d0"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d042a321977d1bfe70285dcf30e674aced665da2ba7dc4e0cae31bd928c40d37"
    sha256 cellar: :any, arm64_sequoia: "684b9ef73ed88ca5701bdf3665a8dbae42e816117e4fe0434537a21382ce7540"
    sha256 cellar: :any, arm64_sonoma:  "c610f58407202985f7c622abac2d60a6edd93e79c981b70e38921e2193ac4e31"
    sha256 cellar: :any, sonoma:        "df52c00a1a9c03daaa780f2a84483d35344722b08209d349b674aa1464e52eb3"
    sha256 cellar: :any, arm64_linux:   "b8c644b69c98d0681758097034c7f6d9bfd7e114f49a1ac4cd14512a9e2c4394"
    sha256 cellar: :any, x86_64_linux:  "b649089b5f932b02d2655bbf4f121c7ba511d1d9511a9aa75dc57333c1d8bf36"
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
