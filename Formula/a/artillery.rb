require "language/node"

class Artillery < Formula
  desc "Cloud-native performance & reliability testing for developers and SREs"
  homepage "https://artillery.io/"
  url "https://registry.npmjs.org/artillery/-/artillery-2.0.15.tgz"
  sha256 "e5c1ebf5d9f711d7a49503e3f803e9c3df42e9806ae2e479144def80bf4ca3b3"
  license "MPL-2.0"

  livecheck do
    url "https://registry.npmjs.org/artillery/latest"
    regex(%r{["'][^"' ]*?/artillery[._-]v?(\d+(?:[.-]\d+)+)\.t}i)
  end

  bottle do
    sha256                               arm64_sonoma:   "f6ead460aba8750c2c34ad93518c627efb4130c3d9041c1151450ecb2f802af3"
    sha256                               arm64_ventura:  "8bfd7867219ac0e6337bf94386451c53d3cb304ebd1e068084a2e4fa190d31dc"
    sha256                               arm64_monterey: "d3dd21d8d39545bef05cff75cfa8385bf689259fd4afd3f36e13e61176203c48"
    sha256                               sonoma:         "bb6b3d09c77f25c4913f08786082f207527a7af4ddc78923be7997eab9ed15b8"
    sha256                               ventura:        "99cd243bb43a05749e7957088589b0f4482786f5d1c16ee73fba959c89c603fd"
    sha256                               monterey:       "63bc8c7f0af91b31c7d56894e467fc7a6a9c67174dae6757027f99f2e95ebdf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb3b2eecc84a7502d33de20087d15c004c652abc2f06ce6b3d6d65d04ce52cca"
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
