require "language/node"

class Monika < Formula
  desc "Synthetic monitoring made easy"
  homepage "https://monika.hyperjump.tech"
  url "https://registry.npmjs.org/@hyperjumptech/monika/-/monika-1.8.0.tgz"
  sha256 "07caa733153f765a5ce570a9a6234a67ef09edf0fcb65427cb0706d08a0ed63d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3b5bc8f674e66c0135d2760df70000a2694399bec5e565dd669926e586f5640"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "941c3a4e78b6efb4d82f306b68b2ceb06afd687a53a82963cfcdb4b397c99cf7"
    sha256 cellar: :any_skip_relocation, monterey:       "7331a77a0895337368ec1ddea823e2f28c643d6ab98c107b7c6134e2cc6524f3"
    sha256 cellar: :any_skip_relocation, big_sur:        "1fe9532209a696415cc99fc465d6d8d83cff467da714ea6468b551a231f783fc"
    sha256 cellar: :any_skip_relocation, catalina:       "d38d58b862b411d3c2e1e3ec4778a46eeeaca951ee4924d5222f49a2ebe3e764"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1005a78b41aaaea32e0b1b3164582c084733c3c10b06dac67ba22cfc53bb5d16"
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
