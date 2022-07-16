require "language/node"

class Monika < Formula
  desc "Synthetic monitoring made easy"
  homepage "https://monika.hyperjump.tech"
  url "https://registry.npmjs.org/@hyperjumptech/monika/-/monika-1.9.2.tgz"
  sha256 "d07fc19694289cba94e26c07ce6070a93c9b77e77459a9047f54b724b3d9d785"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "246c3450529d8601e0c0e1deaec104a510f2c3417101752310c90afc84270140"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f3ab8df13558e78e209d339ab07654ef5b36c21e468f3cf930031965d24b765f"
    sha256 cellar: :any_skip_relocation, monterey:       "12895612098aaf9a1361d8cbc0338a51a5aff5523a640d5b3b636b312dd13ebc"
    sha256 cellar: :any_skip_relocation, big_sur:        "19656dc7d9ec9a5845deda291b47c34c45ab9998bb524aa7645a4bc67fc7b762"
    sha256 cellar: :any_skip_relocation, catalina:       "c33aff8f8efd4dff307b6928520bae7a5fc7291f53a5df0fa7c4ea746e5cc54d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3faf1c0fbdec02311f4fd0b7c93f21091a5ceb06c74a78f1d278ceec4179f29"
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
