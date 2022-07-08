require "language/node"

class Monika < Formula
  desc "Synthetic monitoring made easy"
  homepage "https://monika.hyperjump.tech"
  url "https://registry.npmjs.org/@hyperjumptech/monika/-/monika-1.9.1.tgz"
  sha256 "1294f67b03df4682273a75b3d2d1022bcd3f45a944347a11bce03b2b70997072"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93bff965d37f1b3a45efded923fd4243f2de2fcc485c5360fa2fea626c9faac7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9dab1f3918d54d3c17dc18acdcfde755950060981833443faa777f7f5ad64bf7"
    sha256 cellar: :any_skip_relocation, monterey:       "5d3d74cc18e79b0b281254ea330157c3a59f45d38a1f5ec20b2e14bbeff58dd2"
    sha256 cellar: :any_skip_relocation, big_sur:        "98d0f113b8a390736cef0fb5b92f8243de32b068bdefde001e33aea3290d95c8"
    sha256 cellar: :any_skip_relocation, catalina:       "1aea242aba4f0d58ef9ba2cb9fe98f687d5f534e6c2cc358a446a1422295a05e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2cafeed84449b1249fedb6d91decd8398d26d42831940fb60d83251f3a14133"
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
