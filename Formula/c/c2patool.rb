class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.16.5.tar.gz"
  sha256 "9e593ffe7f27ab760fb17caf3143ca7e445158d702f035ab9a839c4c465dd83b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e1fda9e446b1765c2f10eb3fcaaf967f3c705aaee390e29ecf58603e0341a05b"
    sha256 cellar: :any,                 arm64_sonoma:  "5e4c1836850836365e9723eee40879a3f5d6b06838ecd1920ee0f4fd8ecd36f7"
    sha256 cellar: :any,                 arm64_ventura: "796b7bcbcd05b1a31a1793a0aac9b49cb3e9a0a6c2f429d872d1948aca00e02f"
    sha256 cellar: :any,                 sonoma:        "0f81244ee65ec25a7fd1a0c0e78bd36d784ab93357c2305c4e556f4174115d66"
    sha256 cellar: :any,                 ventura:       "d293283a0de4334004e5ad2377071eb6871c8c0b63cb5ddcc49f9596929d759b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b74e969d72ff3039f61a8f7bd34f3abbe1b456c9e1ff8f4cffa0d3cd1361216"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83b08d092a1dd277cbede2d51420987e63936f4e3dd6716564d093dcccd18f97"
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
