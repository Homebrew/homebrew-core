require "language/node"

class Monika < Formula
  desc "Synthetic monitoring made easy"
  homepage "https://monika.hyperjump.tech"
  url "https://registry.npmjs.org/@hyperjumptech/monika/-/monika-1.18.0.tgz"
  sha256 "348c8a7b26497c400695b1892aad143abe753e17f84600520658de3893add990"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "d8310d8fd5621d786b6b3adac05ed55eeba6f0624946bc52fd4226ede609d35c"
    sha256                               arm64_ventura:  "5798ac8bfe44dd94680f54a6c06b4d342ed25250804039fcc28b821736fda205"
    sha256                               arm64_monterey: "4fceb8edb0a8bbaf78b1d9771cf28c40543676a19113a417b8b0d1796bbb0ba2"
    sha256                               sonoma:         "1e6f41a51a336c33f62c583e4103908e09ef2dcc2a0eb158b5c9637d6346ded4"
    sha256                               ventura:        "aab775db4c0b1cd09490ae5558af9de4a7b9a23d2ba850955bf0fb3474fbd23c"
    sha256                               monterey:       "1125b64c9fde33831ca4c5d9b9f28292599d9d0d45a72920a2015a29c8510d21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d85cfb8a9195a53fae26876ab2f1f02da7972308ce186319b3a66ebdc6ea0ca2"
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
