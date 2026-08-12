class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.27.11.tar.gz"
  sha256 "3f0fdbd780decea1bf138c9e59c894b9435850ddb163bbbf73459c1ff903c788"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1a345d97328a4305bf650f3a4688379336238798f6c9414c2de586a7af593909"
    sha256 cellar: :any, arm64_sequoia: "70b82e53709cca71ecdeaa1a197fcfac6c6fc4590ce9b97ae7d5b5bf615e04d5"
    sha256 cellar: :any, arm64_sonoma:  "505f01981987791d41ce3ff3bd10bf67abfa7ebf3985a44d7ef2da36a9c859c3"
    sha256 cellar: :any, sonoma:        "7f67c276f123dedf5c0599c83376ca07cc728ccb5762b1a122cf91fa4a2db508"
    sha256 cellar: :any, arm64_linux:   "7d64a6587fbc8b377346e50291f852f0c9d31cc80453035c4c2f2733a092e96e"
    sha256 cellar: :any, x86_64_linux:  "c63cd63f8540e5582b61064c95bf9faf89a432870a0bed118d7154ef2ffb3c1d"
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
