require "language/node"

class Monika < Formula
  desc "Synthetic monitoring made easy"
  homepage "https://monika.hyperjump.tech"
  url "https://registry.npmjs.org/@hyperjumptech/monika/-/monika-1.18.0.tgz"
  sha256 "348c8a7b26497c400695b1892aad143abe753e17f84600520658de3893add990"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "2ddbb36d583ea578e1c56d12c68f8a139ac0862f888f54e4f271ef129a5288d8"
    sha256                               arm64_ventura:  "fb8bba85bdcb6939587f416473d38872edcf5009856d1295476e51299a0e74b4"
    sha256                               arm64_monterey: "866c9e3c2bdeae57d755ace447ef3427a88faa5ed4dbeba652797c7beee3813c"
    sha256                               sonoma:         "d7a26d87c1a1738bf252400127167990556949bf51b823b2e9ae4f8f06aa9bd5"
    sha256                               ventura:        "e5def8c2ca8cbae39f8e37957165cad984db6e946103ed7930b7a451715b8301"
    sha256                               monterey:       "1ddca5029a2f356404482fb508b18c0ff3c9f05a16396fed14508b81f5dcfd35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43209c72082acfe55ec8787ab845b5e00b545942db6eeea41bcce41a7a16c5c6"
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
