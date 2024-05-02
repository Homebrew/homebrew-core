require "language/node"

class Monika < Formula
  desc "Synthetic monitoring made easy"
  homepage "https://monika.hyperjump.tech"
  url "https://registry.npmjs.org/@hyperjumptech/monika/-/monika-1.20.0.tgz"
  sha256 "c827c94be168bc3071b967aedb4b278931efa42fc15a2241e94910899ae84e27"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "89d5260c1ee564d20c09923f44cd669406500fd3eb4948f83e1f9562fee4900c"
    sha256                               arm64_ventura:  "87d9b685200f665a23400b904d19072176a14472bfd17dd73d9ea064c3b37989"
    sha256                               arm64_monterey: "b013b4ffe755fa238ca5c2d5bcb7a7a49e8b8849e80da7b401a15fb6b06acae4"
    sha256                               sonoma:         "c37d80cbe1e5a944ceb7f5d13cc7bffe4e63d7ff6c65f93c9da84bef74320d68"
    sha256                               ventura:        "e301b3ad6e67c0350f60c50846ba545eec833cf64abbdacb6c309160517755bb"
    sha256                               monterey:       "16371f347daa8b556af38e5ddb30091965c6190ec98fac7031262392db80dc72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d94076944b783a960f465bace47689cc5eae9c3f4df39f4e53a4e6435cfc88c7"
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
    sleep 10

    assert_match "Starting Monika. Probes: 1. Notifications: 1", monika_stdout.read
  end
end
