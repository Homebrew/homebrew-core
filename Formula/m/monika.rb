require "language/node"

class Monika < Formula
  desc "Synthetic monitoring made easy"
  homepage "https://monika.hyperjump.tech"
  url "https://registry.npmjs.org/@hyperjumptech/monika/-/monika-1.19.1.tgz"
  sha256 "41eba7d4c485e6b42dcf0673f2780ad802dfd940dbbe18e289ff37a66bdd30d3"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "d24eaf1ed79ac4cf7acec502bff0e1919e0c3c263aa4aea6e9e9777d42d09f2e"
    sha256                               arm64_ventura:  "38050fed4da64e02188df12d9f9d70cc48e9214719a911402f8c93aeac0fc7c3"
    sha256                               arm64_monterey: "1b18faf30b094a8ff94eade5a62e4e28672ce6bb21941c5017777597a719d8eb"
    sha256                               sonoma:         "19c95cd9c4febaded6b0f2981716555d73c051c239e7d49e239a8adebf82a8de"
    sha256                               ventura:        "2896617a58bde7839ffde1cddf2d7cd28f4fb0fc0518e24c1a8b26d479b1d7f2"
    sha256                               monterey:       "8937f4033d90b200e03c0bcc760e565a7248ec60a78cb6e59abb6b1cddfc1b90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e30b88fd7ee7f95ac42e4d5e76bcf9844d416b97ed1ccd3cb223acdd955a3f13"
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
