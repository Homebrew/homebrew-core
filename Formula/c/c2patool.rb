class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.39.tar.gz"
  sha256 "ef0e389ad89810fbe8c586f447f44eff4a1e093915573747755ef4d0a966bc39"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a3a4305402fbc27fcf67e9522a883f50799e86fda40fb20408cfd9fa176bf6c7"
    sha256 cellar: :any,                 arm64_sequoia: "764dca55c7b0f14490132a374fff6bda7aa1d299318a5eb4a5a092ee27aa88e6"
    sha256 cellar: :any,                 arm64_sonoma:  "b72acc0cf04404141d11ae9aff0403d8e45d3b01e5c7885b021dec5714576304"
    sha256 cellar: :any,                 sonoma:        "64468ff381be026f0b47e8463fe06308b8ea129bf951aa4561f7bcfb32d9a527"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55a19933dd1d9d5e020c170faec43635ec9f26b67aea3b1fd8bf81b6d123127a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f237b6dc92db2f76295b17856fdcea73ad6b52971a50359c641654218bd4e9b7"
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
