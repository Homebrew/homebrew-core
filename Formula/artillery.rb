require "language/node"

class Artillery < Formula
  desc "Cloud-native performance & reliability testing for developers and SREs"
  homepage "https://artillery.io/"
  url "https://registry.npmjs.org/artillery/-/artillery-2.0.0-28.tgz"
  sha256 "dd2270e6056923595b6dfa59c1b8548d5bc92539ce984b9fa2d0584cd2fdf6cc"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(/href=.*?artillery[._-]v?(\d+(?:\.\d+)+[._-]\d+)\.t/i)
  end

  bottle do
    sha256                               arm64_ventura:  "689f156fe8c6256570e4704356a584f42a1434bfe2e368af659ef8aba7a1d6f5"
    sha256                               arm64_monterey: "7f199224a527716d8c6af0d65491ce767503aa110f2972351cd36b036782caec"
    sha256                               arm64_big_sur:  "a9e903c34a6c236a011e09ba8e21e69b928ca40f78cd253899d819a35259c68c"
    sha256                               ventura:        "ef60129fba71d8d4558bc87a02e64d755525bc9c4b91f2012a068cfe85cfc887"
    sha256                               monterey:       "65e48f1b3ccf5968a3171c3694f06844f5d6b3ef736468ec24d1240f470d1932"
    sha256                               big_sur:        "5064e677ccfcbbb4d5f65cca0e320c5950ad93a8a93066fc81b041f568f48373"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a21471fe1702592e81963cc2a95ccbfe6c7c3e26551e57d573f6c7e2af8de80d"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with native slices.
    deuniversalize_machos
  end

  test do
    system bin/"artillery", "dino", "-m", "let's run some tests!"

    (testpath/"config.yml").write <<~EOS
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
    EOS

    assert_match "All VUs finished", shell_output("#{bin}/artillery run #{testpath}/config.yml")
  end
end
