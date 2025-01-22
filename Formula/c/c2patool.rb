class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.11.1.tar.gz"
  sha256 "f4ba182f88242ac69bf73ff33d2fd11ba460ae49b28b333aaffd573ca69bb2bf"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2febe9bc7da2dbf7ca0ceca46799f08e82bb2ee34e7469ee5ac44c68c531267f"
    sha256 cellar: :any,                 arm64_sonoma:  "5448b01a63662702af3c28d35f1276e2d05108ae16b7dda8d9a2ae79e7bc3e15"
    sha256 cellar: :any,                 arm64_ventura: "5eb46b393f3b595b01651a20d0d9cea3bc755ea4d8bef537e93334e83deeed64"
    sha256 cellar: :any,                 sonoma:        "25de7218304aeceeb903134eca7c1d75ad01ae6a645dbe09c38b0137b928f648"
    sha256 cellar: :any,                 ventura:       "07b14818377e4d3117a6bd033f55d8444035c5fc654366198df8c983c03f9192"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd629e27beb64b104d2e1c27434009421e495f3b885218dfa8af9ddb08cfd66b"
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
