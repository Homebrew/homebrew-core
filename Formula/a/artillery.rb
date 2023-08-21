require "language/node"

class Artillery < Formula
  desc "Cloud-native performance & reliability testing for developers and SREs"
  homepage "https://artillery.io/"
  url "https://registry.npmjs.org/artillery/-/artillery-2.0.0-36.tgz"
  sha256 "850ef6c54bf657ac0a2e4fcf033665d049d9cd5dc79dd42edb7b9183a4cc7b7c"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(%r{["'][^"' ]*?/artillery[._-]v?(\d+(?:[.-]\d+)+)\.t}i)
  end

  bottle do
    sha256                               arm64_ventura:  "c18941c7743e0ecc5b22e1ac93ed07618139b0ed53adbcbe90b52c40af7de5cb"
    sha256                               arm64_monterey: "819f6c38fe89d16492880d773a411995df1cabf57d92b686fc081b782ceeba0b"
    sha256                               arm64_big_sur:  "fdf909e179fdaafeca929e00e2fb121762690c40030560866183717c431ab6f2"
    sha256                               ventura:        "33bffcdb3d9f09a01a8b6287732b43a4fcab6e5e058c51cb585aece301382a87"
    sha256                               monterey:       "5defe42c687e6e9341afb290b50f9af13288c947983e026a0a002ef6819bf356"
    sha256                               big_sur:        "875c025a91c77b0115b82ecd9be28d704d0415c9e442f4990f59be55ded77c17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3afa035439f247ccf633426a1c9f63f6ab9aac42ca697ee913be36ff1f1a9d7c"
  end

  depends_on "node"

  on_macos do
    depends_on "macos-term-size"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
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
