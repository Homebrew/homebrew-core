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
    sha256 cellar: :any, arm64_tahoe:   "c95f28351f861bad5c9569c85ec6ddeb8655d49ad86b10b1d655a26e8e698e4d"
    sha256 cellar: :any, arm64_sequoia: "0c1540b5118d4b7680127033eeba71e517bd081a9d5a9344e45b469a6ad1798d"
    sha256 cellar: :any, arm64_sonoma:  "0f4d945e0e6f004ba18fdbb785234ae486e304cf78aef7b434c0e7af65044f0e"
    sha256 cellar: :any, sonoma:        "a8e8c87d6b433b8c4d8350e8075358a76f9508627df03cdb11244abc2ad3e1f2"
    sha256 cellar: :any, arm64_linux:   "3e0227f7bf676ca11b4e768c07a11d3e71788528c4714d599191a04628aa7832"
    sha256 cellar: :any, x86_64_linux:  "531ccc113b9827e9a32af84019bb6b3864bf4b19efadc4b908bebe86d416604b"
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
