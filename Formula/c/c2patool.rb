class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.46.tar.gz"
  sha256 "a9eab7b848d1117c6603c138f42b2ac927528131090a661cd0c1b280bf3feb8f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ab118aef02c7490bfb8dd11e917ce6a263dd339c267aa9b931836471ea99ba05"
    sha256 cellar: :any,                 arm64_sequoia: "87c9563ba0d93e587ec5895d4e6c828b89a818f1ad5d8b9173200472987b5e25"
    sha256 cellar: :any,                 arm64_sonoma:  "612f942f0deb960c444880d9b5868b571eb3ae4cde095830bc70522c71262864"
    sha256 cellar: :any,                 sonoma:        "447c07d071f1e39c75c6a48be926af7c5ee29de21fc9a57f4a7a28e62b52fc81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b3b275bb2650a12f0d0fc92b1f9a5740501a3ea4cff4dc8b5bc6d0a102af41e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "671d5a7e1fbc3a9b356814cce45925c75ef53e3447c6fc507481292bdf464393"
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
