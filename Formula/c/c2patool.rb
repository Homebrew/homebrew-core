class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.18.0.tar.gz"
  sha256 "4095081e6c9dd6f01fbcbe50d8ce8deb317b3b170b48cdcbbc8a722537e09a42"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c68a75d8ed9f537fd95fa9d30041b5c03f2b6436098c258c98c135503b27d996"
    sha256 cellar: :any,                 arm64_sonoma:  "db2454972b9af1468985c486914a297fbe995dc6ff69e8757a489e0e4e0f755a"
    sha256 cellar: :any,                 arm64_ventura: "cbc5c7d180202c7fe52be698cecabd23be26578bbd5730b19bb6507e2e3dbbe2"
    sha256 cellar: :any,                 sonoma:        "61dc8a5f672347161eba3b88c331499616c9a86054fa00e8880184d08a1de767"
    sha256 cellar: :any,                 ventura:       "ac2a65892cffd043b30519c8e8bb600685dc3adc615720e3abbe9955f3cc054f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a87b511e9b18a4d27e7a4f00b4a99dd20fda3632162afae32a246ce5b726d61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d782e46fbeb7b605294c9365656a4646beaebacb28ce9a030cbbaa5bd5b58ec1"
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
