require "language/node"

class Artillery < Formula
  desc "Cloud-native performance & reliability testing for developers and SREs"
  homepage "https://artillery.io/"
  url "https://registry.npmjs.org/artillery/-/artillery-2.0.5.tgz"
  sha256 "489a4d9515886710f3d02429a9fa163b691e7f1f6d36fbd298334e5514e4cf54"
  license "MPL-2.0"

  livecheck do
    url "https://registry.npmjs.org/artillery/latest"
    regex(%r{["'][^"' ]*?/artillery[._-]v?(\d+(?:[.-]\d+)+)\.t}i)
  end

  bottle do
    sha256                               arm64_sonoma:   "7462d6d53b92b210d3598ae95bb94e8d3701c4e365ffb8928656bd2cc23c2cee"
    sha256                               arm64_ventura:  "3894d93d47c90329d8d798d51d16acdeb02f0c7a4ba9b646c1b9129b975be6c8"
    sha256                               arm64_monterey: "1b6637fc4ae300633c10f83010a26d82fd5f420ccf20b336872074a0857b099f"
    sha256                               sonoma:         "2f743d36af307a5545085cf1db65a509309d0bdc8492115cab80dea21cf10a26"
    sha256                               ventura:        "8ec00a55827f819606f55a57c2027f02679d5c8c4ae55ce18b7debbaf8aadebf"
    sha256                               monterey:       "2619085a3a640aa79feec0e62c4993f2ed3c0e836f550bd4a46ba1ea128a01cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e8138bc3c5d475484bd22ae0de884e3a33b76d995799ea99cc6404b65e77fed"
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
