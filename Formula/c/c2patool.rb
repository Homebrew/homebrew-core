class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.11.tar.gz"
  sha256 "c18576bd0dead6f6734927f0710487e1cde31560434a5b94f0fd360e27182390"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "74b5ed67e3b1cf0b45fb88fd3d67e94148e23af46f2ca8b76ed59a078dda182d"
    sha256 cellar: :any,                 arm64_sequoia: "f262c7f5134c7986cdec196c6280db64ff6a5827b4adddf4d956c1a81b6f7e03"
    sha256 cellar: :any,                 arm64_sonoma:  "6ded91558bdf027ae488767c738b1af9a4924536b04293d97095a528985097b4"
    sha256 cellar: :any,                 sonoma:        "69a0701a505f5dcff14d34ba54b34c3811e5b098acce9034a9686e56ef0162e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "abcecf3a3f6c50f5be7c2576df683ab118a8114dede692195cd5a9f276c6e956"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "058af5def14c2fd5674f9b334babbf6c4f4513b013e3886d8a38d91a6141444d"
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
