require "language/node"

class Monika < Formula
  desc "Synthetic monitoring made easy"
  homepage "https://monika.hyperjump.tech"
  url "https://registry.npmjs.org/@hyperjumptech/monika/-/monika-1.10.0.tgz"
  sha256 "e8ff67bda45653944e772e4912998640bbb5268408bc3c29dfa1085677c3b62f"
  license "MIT"

  # Linux bottle removed for GCC 12 migration
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ea49ed3a6e291e1253a800e63527254717b68f3ab1f8237468e976529013a14"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "87ac0d429541ad0645203b57858e970aee169148297dbe66aa0599cdf49af51f"
    sha256 cellar: :any_skip_relocation, monterey:       "ffafad74fa6b66e440179ad8a85f6470b40be61ee78b0d290d05a9b2f92ad5b3"
    sha256 cellar: :any_skip_relocation, big_sur:        "f41b2826a2ec61d682bd25b6a3cd875879777c98e381554420c0b7bb2ce682dc"
    sha256 cellar: :any_skip_relocation, catalina:       "4fc0ce0171e815f85d145764e523808ab34205a09d41bb7c11796a097b3b2011"
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
    sleep 5

    assert_match "Starting Monika. Probes: 1. Notifications: 1", monika_stdout.read
  end
end
