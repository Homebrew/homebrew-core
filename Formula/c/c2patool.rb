class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.12.0.tar.gz"
  sha256 "a52c7d9895c3f2edf9884dc06c9e96f9067bf81fa99aaf26bd22145d503d6fc3"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4626117ccca77538977a7dc0075f8fd25de9f352b53a3eb6bc981919b48b400a"
    sha256 cellar: :any,                 arm64_sonoma:  "57ad56f0700986136e03a182e2c7051184811f431bbf6e789438ae521949b1f5"
    sha256 cellar: :any,                 arm64_ventura: "db0a70f5fd26e5b5c926d1100a3ad4e0609795b996bd091065179d6acda39605"
    sha256 cellar: :any,                 sonoma:        "682e61766cba331c900117de21723e0a1afcafb9d7890fa904778161929e8bbb"
    sha256 cellar: :any,                 ventura:       "82e2999355ba6e41fc5ca12fccbb2889b27d8432b1e4e68974a466f79c3b0517"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "478bc0d37575cb327d3898840a6e38d4c9ae97d892c7e5021e44274989c6421c"
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
