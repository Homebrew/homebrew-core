class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.51.tar.gz"
  sha256 "49b9e884e773f132883ce81171ed34d542370c061fc9ba78b57cfb439908042a"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "66404e7cb5b13ccac689785c2d6050c35c1194c4841ff857df7cd49ab04b84d7"
    sha256 cellar: :any,                 arm64_sequoia: "ef99649c038ce595dd23fdd79d75a68e53d191a53b6f8dfa535a8f31fe2b8aae"
    sha256 cellar: :any,                 arm64_sonoma:  "1ff4909c5bb305ccb26285524d08311dccc010be3de1443fd43d693cb2adaae0"
    sha256 cellar: :any,                 sonoma:        "dd7987d6fe9a7fa516145bdc865702d7a2a8da2ed59b62e6f6e7a04ea910cffe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c1dd9ab08b39670b1ee8e4c2e76073a10df9817c3f6600f3c818cc725eed1b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "454c2e17503291a05b078ce682b59bae7794a2036a341b69a16f928bb4bb27fc"
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
