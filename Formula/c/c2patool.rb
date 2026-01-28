class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.19.tar.gz"
  sha256 "212925d62643da953289a87ba97cee6657f7cd657e3868cd2a012fcc0572baef"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b59585b50dbfb4a62d4e18ff83314752a9409c07cc207128bef03acdbd47869c"
    sha256 cellar: :any,                 arm64_sequoia: "7e8777872c8df7b058d7510366f65139dfdc305fd2ffb2dbfc68c72ee69f5961"
    sha256 cellar: :any,                 arm64_sonoma:  "86745c6179d1ffe9f1a6bedf8e51f964a35816283e2b7f34296e96fce97553d1"
    sha256 cellar: :any,                 sonoma:        "28d66fc37ddab845581d129d6d09758e07e37e92e15d81bc59b51faa4bcf4c7f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69185831d63288bdcb09ad726059d85da7ee96ec0404950c8a491175f5051656"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3150d113b9fb852b1f17877def23b96f9275b1aa9734e80f397f014be099c9a"
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
