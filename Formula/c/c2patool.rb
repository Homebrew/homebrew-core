class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.62.tar.gz"
  sha256 "c2fdecb2511f0d54d6dd5bbc243fe0d3ebb5c13e9cb5bbe0138e08607357af5a"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6e4d70a410c499600f7ef040bd8ef5d55d6eb773cb727e94c9bdacbe48e6310c"
    sha256 cellar: :any, arm64_sequoia: "3a2cd918e773b25c0e248488bb51d3819c5f907fc82d628b064de09e41ea185d"
    sha256 cellar: :any, arm64_sonoma:  "a59c3c4f80b9fd346b6bea3e97819f64eb7cc95d07ca4844157e1ae86e5f45bb"
    sha256 cellar: :any, sonoma:        "7543bbecd7b92fbc85fb14bf3cb6df3c1864375b160af40d68dc39545abadb95"
    sha256 cellar: :any, arm64_linux:   "cc813078ed03ddeea5e046793d941a428bfb55b95cb8b1db94ae3ce3caab2138"
    sha256 cellar: :any, x86_64_linux:  "dfa6680e18ccbf494ff251b81e290f5d1adccc04fc734631df9b7d84c955533e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@4"].opt_prefix
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
