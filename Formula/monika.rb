require "language/node"

class Monika < Formula
  desc "Synthetic monitoring made easy"
  homepage "https://monika.hyperjump.tech"
  url "https://registry.npmjs.org/@hyperjumptech/monika/-/monika-1.10.0.tgz"
  sha256 "e8ff67bda45653944e772e4912998640bbb5268408bc3c29dfa1085677c3b62f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35cc383eb28ce47024d746c02b89518e89cdec9409ec6bfbfbf3578f6a10f686"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "58d54a62eeb79e5f6f126fd5a3bae012a6baaf501b2864150ab7a7c398679122"
    sha256 cellar: :any_skip_relocation, monterey:       "c0a35bb82d8e937ab88448a3592533c0d1ccb7950bb6fa76942365069682559a"
    sha256 cellar: :any_skip_relocation, big_sur:        "4848e54f9bc1ac964a21cdcb6ec816d631001b34d8a20b12ce47bdfef29d0017"
    sha256 cellar: :any_skip_relocation, catalina:       "b987901968fe9404e8ee98269795d24a81ff49fe538cb206bdcb90d26fb701be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28e0f500317e27b74c51883e777ee904e1dd08cac6a886c3ce0ed2f55c770a67"
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
