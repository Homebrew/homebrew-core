require "language/node"

class Monika < Formula
  desc "Synthetic monitoring made easy"
  homepage "https://monika.hyperjump.tech"
  url "https://registry.npmjs.org/@hyperjumptech/monika/-/monika-1.8.2.tgz"
  sha256 "901b4bf70e16c375fa2d6f6aa9e4c29ad9cd613e52d2aa57f7e6bb2407a815e8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "efc276ed6fca6e6fc2874394ece67712ecc0f2e8873f7e7292bfa2ff3af1c290"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1d86c0f3a8855de49a3b15e1097e8846e16622078f09a059afe6ca1f0e4387f4"
    sha256 cellar: :any_skip_relocation, monterey:       "080e53efb84aa33dac2bffa4a68fa2373c7034018b122c6b453392f50cdee043"
    sha256 cellar: :any_skip_relocation, big_sur:        "02d948bd00d6b6ea5c3f9b98489b3ea5aed8fa1f02b5627c50edfed76ebd46a2"
    sha256 cellar: :any_skip_relocation, catalina:       "ab18020388bd8f2c44ae50651b38250bc3779180075004ae38e3ee3b8ef16323"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cc278bbac7b37c519194c32218afa17f5bf3e06c895dcc247ad109c4146ff6f"
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
