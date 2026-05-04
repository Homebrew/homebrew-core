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
    sha256 cellar: :any,                 arm64_tahoe:   "7f513db3985023864848fedfa25b059144c65f6f6d5f0cf4839de40597f95442"
    sha256 cellar: :any,                 arm64_sequoia: "6bde3d00b5d58f5a370029def81b8082cb8060d472a1e01dc332c5c6256bcf2d"
    sha256 cellar: :any,                 arm64_sonoma:  "cb2f279e4fe9dc88db6d0b53df0e88fd2c7086995b29949bddd67e25a278ba14"
    sha256 cellar: :any,                 sonoma:        "8531b1ebe611c3da86b3185967c2a8f3384df923ed1e28d22ff5043e298e9b6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb213720ab68deede05ca6647a65da5ae89947ab07fedeb6e0bb77ac7b6bbb28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0dfd271d7cd84e3662d58a269a6a9d00df218d8f1ddbed22a3a91084cfab276e"
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
