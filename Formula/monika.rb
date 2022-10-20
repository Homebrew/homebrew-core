require "language/node"

class Monika < Formula
  desc "Synthetic monitoring made easy"
  homepage "https://monika.hyperjump.tech"
  url "https://registry.npmjs.org/@hyperjumptech/monika/-/monika-1.11.0.tgz"
  sha256 "efdb34745a1de2fca8e918ee69577feee3f09a55bd6f5f6e1cddfa9f058ceeaf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa5c21c238bace78d7f665bcf5754461f4583fc8e6268412f45b09f31ac61b4f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "680d0fb4f40e7c47614f4cfc2e0245662e20a09cff592c85b491874451fe3216"
    sha256 cellar: :any_skip_relocation, monterey:       "70ec69448990d413b2116d17c57d94f30d20f9c6c56ab84bdb0cd9b8c1e922d9"
    sha256 cellar: :any_skip_relocation, big_sur:        "98318750b359f8dc6b5f64b3c869acb0358ab99f542b8654cc942395d208bb1f"
    sha256 cellar: :any_skip_relocation, catalina:       "e9ce43a708f271f42e0ec0c36cc6f9fac4fc90cfebd4b7b263951ec5c0e84ca9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e428eb84abe4d9abba4e9d20e1cd38e6d8114aaad0e02640a2babc52005f4b0d"
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
