require "language/node"

class Artillery < Formula
  desc "Cloud-native performance & reliability testing for developers and SREs"
  homepage "https://artillery.io/"
  url "https://registry.npmjs.org/artillery/-/artillery-2.0.3.tgz"
  sha256 "84eb2b57ce8765342598b8aadf513ae5623d581c5c5acb2c3d650e8b6873e4ba"
  license "MPL-2.0"

  livecheck do
    url "https://registry.npmjs.org/artillery/latest"
    regex(%r{["'][^"' ]*?/artillery[._-]v?(\d+(?:[.-]\d+)+)\.t}i)
  end

  bottle do
    sha256                               arm64_sonoma:   "479be2e73a6ae48341aaad770aa28b35da5bfa42c323abaf8a7857a4596b9aac"
    sha256                               arm64_ventura:  "18e4bcb34f078c52d26f26c9521dac9c03a73057a9cc71d67686474dd726eeb8"
    sha256                               arm64_monterey: "837f5346b77017993a016923ccd78b35af71864304e4422dec75e37447583da5"
    sha256                               sonoma:         "dc77f90a3f99c750b6df6f77cfa72fe885b205cc3ad90af2b27b36fdff24ce66"
    sha256                               ventura:        "8e7ed22abd1a41f1835cf285c1b3bd3b49def7a62e5ab744f1cc9eb1b33138da"
    sha256                               monterey:       "80e2e962819752a0a4d769906ec7eed50a63475add9faac683e48dfddb75ba85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3d23df0dbf287f586b540cd0a27af829e7fdd9b80250051f30b710fe85c5846"
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
