require "language/node"

class Monika < Formula
  desc "Synthetic monitoring made easy"
  homepage "https://monika.hyperjump.tech"
  url "https://registry.npmjs.org/@hyperjumptech/monika/-/monika-1.9.3.tgz"
  sha256 "b26ea8d25a28340704530587dbf00a9db64f80e3937a66ccc62d6d57c1907445"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c6aa1d7e1d1b31d42078ef42277a1bfdcb78ec0e79f77024c4e21d198206326"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "787ca02b283a92280778e651334388c8c71b1949956cc3d305d47706ed40d819"
    sha256 cellar: :any_skip_relocation, monterey:       "728c3968a4b04e1a56cf8c30e8ad5de422332032750e6fe79833334f72fc5a57"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ee2d91018277e4c41c3b71da6993fcfecd7746be8ac42a20bedf582d725718a"
    sha256 cellar: :any_skip_relocation, catalina:       "eefd2d917902047a33e904c1c99b1c29ce3935db2d703e4cbdf898e7269d9042"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3bff78c9b9fcc319946ce3948b74f6e99500530a46b8be2206d7e43f03ddd71"
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
