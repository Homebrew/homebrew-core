require "language/node"

class Artillery < Formula
  desc "Cloud-native performance & reliability testing for developers and SREs"
  homepage "https://artillery.io/"
  url "https://registry.npmjs.org/artillery/-/artillery-2.0.0-30.tgz"
  sha256 "b93162ee46f3273bcfdad558f6ad1849dc2825bdb9af97573bb9446dafa41d03"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(%r{["'][^"' ]*?/artillery[._-]v?(\d+(?:[.-]\d+)+)\.t}i)
  end

  bottle do
    sha256                               arm64_ventura:  "de219ef1043b7c6886b3587cff5a369c4287453d08fc29015144d9fed09d6af7"
    sha256                               arm64_monterey: "7afc52a82a409b9c4680a969a76648edb8226f93a00e4ef34a324ea39102723d"
    sha256                               arm64_big_sur:  "59d9844d5702688a5683c5e4c4625c4709b4790ad4ca809632e0831cb887aefe"
    sha256                               ventura:        "1e8fed4f9fa84ee9855e3601dc4894c2c931abe833b478a9366826d618438fea"
    sha256                               monterey:       "325daf09eb003d1a6939330000f184b486f3a71976229f2a82485b726211eaf9"
    sha256                               big_sur:        "1088efe3032c296efd3968b78c79fa6ff1f7a96bb1eeaf231d8e7608530ab24c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c27702ddb9a54bcf4aa43fb28ae0a6394dfc0b7ef6dc795466766e3aec468024"
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
