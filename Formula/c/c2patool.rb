class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.23.2.tar.gz"
  sha256 "0d3709f3edbd34581fa636e65cdae0a9f2316bbce490ceeb23196b3cbbc19dc1"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b2d6a081ed262e9e2bbf98ac67ce03dff9d1abb689aa2a1b567c3866af2fd19f"
    sha256 cellar: :any,                 arm64_sequoia: "a5af12dec5dd8648d75716ab1973791a47fd915a925c68a65d87808f9c552450"
    sha256 cellar: :any,                 arm64_sonoma:  "11de08dee6b1d117d423b840eebd4a143385a630e4008162a6c9052bfca85f5b"
    sha256 cellar: :any,                 sonoma:        "e81b917c8ccb8c58b84765f5da52ae0a7ae3dc880b449d4fb523666fbc16730b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "906e778fb389deb38638330bed3516d6549b0ed5de1a66140f4112b7767c5bfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99c95ddc2a4a617b74968774a5e46f87165e89afd0df3511f0569698307a7821"
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
