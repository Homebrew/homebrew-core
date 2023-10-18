require "language/node"

class Monika < Formula
  desc "Synthetic monitoring made easy"
  homepage "https://monika.hyperjump.tech"
  url "https://registry.npmjs.org/@hyperjumptech/monika/-/monika-1.15.10.tgz"
  sha256 "8a1d8e6bee67c06a1f63da7b5b79f0ec95f6f7b4e48d252bd7c3ab72a44addf6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e17cd8b28abffc7c35fb7db92dc5a1ab9c2b0e27432f975a0549383258aeb83b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "054107699681d5e0d748189557d92ecd6d17eef12afe7a45b71612607af3177d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10deefa8555e015efb49bf597124bfac14aa6dca869cd2b943a4f58ba6c42eed"
    sha256 cellar: :any_skip_relocation, sonoma:         "1e47c501f72a76b99cf6f52b932711aed2fcab2a8b6d9fdfced68fb0186639bd"
    sha256 cellar: :any_skip_relocation, ventura:        "ebd190b4fc42d0cad16372caa912b5a8ddce3e308f7ad019eea03297d40d1ea2"
    sha256 cellar: :any_skip_relocation, monterey:       "7abacad82f86dc1647bbda6ea49b05b71d487620eea7d696db5f114af88859d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dabbae7ce81e1a1465de762db80ad3ee3ce6af540f020ae3d4c00c542f009541"
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
