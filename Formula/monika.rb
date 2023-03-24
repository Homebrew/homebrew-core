require "language/node"

class Monika < Formula
  desc "Synthetic monitoring made easy"
  homepage "https://monika.hyperjump.tech"
  url "https://registry.npmjs.org/@hyperjumptech/monika/-/monika-1.15.1.tgz"
  sha256 "43cf75f0d5ecffb483b9431c57b1c5b887ae3ceb11e24d316c6338556dbac4d9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9a5038ecc0a621332a036b2f5b202357b68b99ddc2fd127e7152cbdce970ea5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0440b95ba3faa9aacd0044b2c678e13ae85dc6f35e7908c404ae0d4c9facf8c9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9f1944d07a0c2515fbd705b6f1cd8862b1f546ce933d01bc8b0cf60765ac6a65"
    sha256 cellar: :any_skip_relocation, ventura:        "5cb89900235bb5fbec4d728f64fc4090dddb99ef493aac4e1f4f5962db5b0561"
    sha256 cellar: :any_skip_relocation, monterey:       "4d85ed13a55c0444c1666e9d6c2b5bc3dd808f78c7a31b24adb16ffbcfc57374"
    sha256 cellar: :any_skip_relocation, big_sur:        "36a102e48988842d13bce34b14de2ee7ab1d22784920a60e58e9ee0cb69e7bc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e15673888c87813da441454125a77118f5baa041c2154866cbdbca65adff55d9"
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
