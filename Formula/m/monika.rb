require "language/node"

class Monika < Formula
  desc "Synthetic monitoring made easy"
  homepage "https://monika.hyperjump.tech"
  url "https://registry.npmjs.org/@hyperjumptech/monika/-/monika-1.20.2.tgz"
  sha256 "ba1f4255c72200cf386f843b7777f26488515009c81bbe68fee77a815bbd4a33"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "4c658e1d25d3f5ab04f2691abc7494780786577746be4cdb5fc00921839b8c54"
    sha256                               arm64_ventura:  "2a6c652e4de5c0075220d369fa42ab703a17325002df3955889779b920ffce91"
    sha256                               arm64_monterey: "79605b8756b331aa6e9eeda4a0835801aae0473698962b7d735b028720547bb8"
    sha256                               sonoma:         "e8311d7202e5e886290b02745ea22c155ecc72caefcf0e5c1ce3181aa2a7f14b"
    sha256                               ventura:        "bda019741f3b94eabdcc43259a45b73e606c31a507d8328628b6ca0564e626cb"
    sha256                               monterey:       "f690c820cc9bb63277b00c3a493deb7080010a7914215115d53f063d55659371"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "286a090a3dc195d9593d36cb56cde5b7a8905a7f927bdfa1548e44b527cc92fb"
  end

  depends_on "node"

  on_linux do
    # Workaround for old `node-gyp` that needs distutils.
    # TODO: Remove when `node-gyp` is v10+
    depends_on "python-setuptools" => :build
  end

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
    sleep 14

    assert_match "Starting Monika. Probes: 1. Notifications: 1", monika_stdout.read
  end
end
