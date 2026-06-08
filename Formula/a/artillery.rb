class Artillery < Formula
  desc "Cloud-native performance & reliability testing for developers and SREs"
  homepage "https://www.artillery.io/"
  url "https://registry.npmjs.org/artillery/-/artillery-2.0.32.tgz"
  sha256 "796be4097eda9bd74ceb5164223f71eb046012fe967ffff288dca705531a60cd"
  license "MPL-2.0"

  livecheck do
    url "https://registry.npmjs.org/artillery/latest"
    regex(%r{["'][^"' ]*?/artillery[._-]v?(\d+(?:[.-]\d+)+)\.t}i)
  end

  bottle do
    sha256                               arm64_tahoe:   "dca938d95f9e90f08a7b46fdfc651eadffed6a3038c7609d7fdd5df0362c210c"
    sha256                               arm64_sequoia: "f384a9b4438e5f56f895a19164a21b06de4a4e0c646ad009c9d67e1eb989ac01"
    sha256                               arm64_sonoma:  "08243ae957d929a2c23891d547c325ced2757e28619c5b4325827d802904b61e"
    sha256                               sonoma:        "b6774f2604d9357122529cde913bff2b17fd301aca1e935dbad3a53d310c8bcb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06fbbc99eb0a7741adf2977fc0e926526767ccf36a8a0c83625f45162c7aa484"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e58158349ebb45b9b4d44fa09ca6331e355f841a7004532abfe30a1310555b6"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args(ignore_scripts: false)
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"artillery", "dino", "-m", "let's run some tests!"

    (testpath/"config.yml").write <<~YAML
      config:
        target: "http://httpbin.org"
        phases:
          - duration: 10
            arrivalRate: 1
      scenarios:
        - flow:
            - get:
                url: "/headers"
            - post:
                url: "/response-headers"
    YAML

    assert_match "All VUs finished", shell_output("#{bin}/artillery run #{testpath}/config.yml")
  end
end
