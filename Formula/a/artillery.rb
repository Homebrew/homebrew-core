class Artillery < Formula
  desc "Cloud-native performance & reliability testing for developers and SREs"
  homepage "https://artillery.io/"
  url "https://registry.npmjs.org/artillery/-/artillery-2.0.21.tgz"
  sha256 "a6582e0389893dc749861d06f4779fc10bbb4ba1501c9b47bfa0dc1ee6ef0fe0"
  license "MPL-2.0"

  livecheck do
    url "https://registry.npmjs.org/artillery/latest"
    regex(%r{["'][^"' ]*?/artillery[._-]v?(\d+(?:[.-]\d+)+)\.t}i)
  end

  bottle do
    sha256                               arm64_sequoia: "c174084835854f3b2aced22c9f0757a812ce5310b881aca219649013af686a1e"
    sha256                               arm64_sonoma:  "3721080d63033b99429b71e2715c959503935393ffa81ff2d3461b1f5f4ad6bb"
    sha256                               arm64_ventura: "60483ff57bf8508616c963d3619ebad3862c0b6172023c1fb2be282f9eabf64a"
    sha256                               sonoma:        "886c98590003880a066bfd51635de8a40fdabc5cf21026ec1a9163ac86e23165"
    sha256                               ventura:       "7a8ee9928bb7fa176ba69625bfc23464efb506618f3120c59f21a625a3968c71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75aa55f1c140266b444bc11cbdd68997443f6e661c4e028beb9972e6eb677c28"
  end

  depends_on "node"

  on_macos do
    depends_on "macos-term-size"
  end

  def install
    system "npm", "install", *std_npm_args
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
