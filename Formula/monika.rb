require "language/node"

class Monika < Formula
  desc "Synthetic monitoring made easy"
  homepage "https://monika.hyperjump.tech"
  url "https://registry.npmjs.org/@hyperjumptech/monika/-/monika-1.7.2.tgz"
  sha256 "ec1e6a934ab1343c3dc5e576dcb73a78cdd6852f8353891889fec0ad4db18bf5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19fe3715963d6e984f2e67d2637db89dbcdb2ffcd8e6789a985560e29dc778fa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "14a0ec8034d7b55867ac01f7bf4f7e57a93adde662596baf71dad28f1e262cae"
    sha256 cellar: :any_skip_relocation, monterey:       "8043c2f1b3d685edf96a1f3a2e782c04af7ffbf6c6fc6e26e6f74c9ee0e9bb0c"
    sha256 cellar: :any_skip_relocation, big_sur:        "5ad8558f950ed38834807d5e9be839c1af87c7f838082daf61cc5764ebe2670b"
    sha256 cellar: :any_skip_relocation, catalina:       "8b3f9d4c78999cf2cbfa602890a576eb2c259b94273b47e1c165659c37e483be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70035f75af0e9bcc1e2f8166b7243ffd7005179df8482eb35d471cb05b89a86c"
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
