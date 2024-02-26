require "language/node"

class Artillery < Formula
  desc "Cloud-native performance & reliability testing for developers and SREs"
  homepage "https://artillery.io/"
  url "https://registry.npmjs.org/artillery/-/artillery-2.0.6.tgz"
  sha256 "a529287f50dcf97f352ed4851b66a3f54dbe48a1c10ee18d15586cd2448bc8fc"
  license "MPL-2.0"

  livecheck do
    url "https://registry.npmjs.org/artillery/latest"
    regex(%r{["'][^"' ]*?/artillery[._-]v?(\d+(?:[.-]\d+)+)\.t}i)
  end

  bottle do
    sha256                               arm64_sonoma:   "0d15b568fe8e200952df7b0cc3c3535ac1c5db695c221dae8c2eee58b8d57cf7"
    sha256                               arm64_ventura:  "246f632ca72c5bb2060eb6cef73ce83d2cda68013e97ae43c6e2fa1efc82d48d"
    sha256                               arm64_monterey: "f0e9779163aa5cbbfe4ddb3bc846a6b9093eb584f624c0a4a3549eb6f03b2bb6"
    sha256                               sonoma:         "4ce6e8b2c0fe4534e527ca9eaf4cafb810d26289a3956b18f1ccc781b04f65a7"
    sha256                               ventura:        "22fd85418fb0e686041faf768c3ee61ebe5494e76ebbe8982b204a74a94c44ed"
    sha256                               monterey:       "5845963d09dd71d2040586b85db3cf712833dd4126f14b550528ddfd8444b017"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c136fbec047b70ad014f30639b09857987e56b97ed6111cb3c4daff024f1f276"
  end

  depends_on "node"

  on_macos do
    depends_on "macos-term-size"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with their native slices
    deuniversalize_machos libexec/"lib/node_modules/artillery/node_modules/fsevents/fsevents.node"
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
