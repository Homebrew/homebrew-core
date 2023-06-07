require "language/node"

class Monika < Formula
  desc "Synthetic monitoring made easy"
  homepage "https://monika.hyperjump.tech"
  url "https://registry.npmjs.org/@hyperjumptech/monika/-/monika-1.15.3.tgz"
  sha256 "c0e00cbd13a44c2b59894488a2149e8d865fcf166aa530ae811d0c5e228dbef3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "64fa965dc058a23908d931558b11220ce775e74ecaaf1dd1a6a0f64ce89f465b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6677d80b7426a5dd9ba44591ec5bacdc6927311ec0090fa10e0d5786faa278d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d1619e5e1f1f56260e21ee1ad0b28504fe1cfbc5246a8daa0884c697278f6255"
    sha256 cellar: :any_skip_relocation, ventura:        "582844f93d217c59f347b537e2dfeeba2dcd3d4ab603e731dba07a95d23ea856"
    sha256 cellar: :any_skip_relocation, monterey:       "b2ba8a8c24b54451180336ea0fe08e5d851b788b66cd784b38b7f5220e202f12"
    sha256 cellar: :any_skip_relocation, big_sur:        "a2aee7ec0992c734e97f13b379b6a3426b97948f630086c88e4adc54dce73f0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30007f4667592d87ff10ef04f09f8a2f4eb983340557a5290f800542278fa9fd"
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
