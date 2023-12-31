require "language/node"

class Monika < Formula
  desc "Synthetic monitoring made easy"
  homepage "https://monika.hyperjump.tech"
  url "https://registry.npmjs.org/@hyperjumptech/monika/-/monika-1.16.3.tgz"
  sha256 "b4dbe5017d383a60eeeba315a9c6c34dc2a8eb7fe6c8f734d3ddaa74f828ae0d"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "c4919faefafbd2b7df056f3673dacdf93e624d548c91c134d33d04b9382cdd06"
    sha256                               arm64_ventura:  "854daaf87bec7c922af97e770448d30f5fd14cd8efb3326d45f6d2e22cd87098"
    sha256                               arm64_monterey: "9049d218069d2110f0ecc742da813156d805ab301359cd306fe8be0701b23177"
    sha256                               sonoma:         "f0db8abf6065eae2b5c60e73986e18a33c4f37a380d1ac20080a7a317528325e"
    sha256                               ventura:        "b4480ab5f66fbfbfb1c9bd52eedd50669a41ca66e1e396a11b9d18b72e8f9351"
    sha256                               monterey:       "981caa86fb4185eddc6052f88d55f9fa4013f280f61475febaf1e5e2ec742bc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4786e3bc865e1794cbf6015389edfdeeb2f56492c2dfa07cae6d83610264995a"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@hyperjumptech/monika/node_modules"
    node_modules.glob("nice-napi/prebuilds/*")
                .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }

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
