require "language/node"

class Monika < Formula
  desc "Synthetic monitoring made easy"
  homepage "https://monika.hyperjump.tech"
  url "https://registry.npmjs.org/@hyperjumptech/monika/-/monika-1.15.9.tgz"
  sha256 "fecc3cdb72c2b370e3fd29e5bda75b70179d032a269429d5ad66e12ec4d2f96e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "103bc555395fe2836fdb4e981c77b1a7bed7f0e2e089fa4c6ff6a02bfd45a2d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c321612656fa4c4ff38f38c71411207e4a0f6046496e18947912c752d9c143e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40f1e1461bec90ceae4ad212dd5ab349d3dd870b97f53b23ab2c2f3b15761d39"
    sha256 cellar: :any_skip_relocation, sonoma:         "d30373b81c3ceebd8ab44f943c915c8bc349d671a78b022ad626a30b41eeba29"
    sha256 cellar: :any_skip_relocation, ventura:        "72a08bf2cf28ab716e91ab7915dd8b267e9f56be1e6c7f9d68ecaa0eb77daa88"
    sha256 cellar: :any_skip_relocation, monterey:       "36289e1ecab562e21e40138049000196b4ada2d8a9887cd2d7b4f29a7ced98a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc392433b35d2b05a811f020b581e5363b3a7a7144997148a89b09b1d42d54b3"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with native slices.
    deuniversalize_machos
  end

  test do
    (testpath/"config.yml").write <<~EOS
      notifications:
        - id: 5b3052ed-4d92-4f5d-a949-072b3ebb2497
          type: desktop
      probes:
        - id: 696a3f57-a674-44b5-8125-a62bd2709ac5
          name: 'test brew.sh'
          requests:
            - url: https://brew.sh
              body: {}
              timeout: 10000
    EOS

    monika_stdout = (testpath/"monika.log")
    fork do
      $stdout.reopen(monika_stdout)
      exec bin/"monika", "-r", "1", "-c", testpath/"config.yml"
    end
    sleep 10

    assert_match "Starting Monika. Probes: 1. Notifications: 1", monika_stdout.read
  end
end
