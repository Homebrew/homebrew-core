require "language/node"

class Monika < Formula
  desc "Synthetic monitoring made easy"
  homepage "https://monika.hyperjump.tech"
  url "https://registry.npmjs.org/@hyperjumptech/monika/-/monika-1.19.1.tgz"
  sha256 "41eba7d4c485e6b42dcf0673f2780ad802dfd940dbbe18e289ff37a66bdd30d3"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "aeafcb3c52f247c1c9126ef2e630c2b526d2254ec18badfdc820812f5edb45a4"
    sha256                               arm64_ventura:  "33f0d8e021321e2a819de9f7f6b91c54c6fad2ac734233fb587a2684755ee730"
    sha256                               arm64_monterey: "f2cff07a9e66476dd3c86c2fd754ba9dd54f9bd09e34a24f8eebe23148d9adc9"
    sha256                               sonoma:         "26820f0b20c62bf5604d31cea32b19d0c3e79a151d3c2462b1e5ef4fd7d8d86c"
    sha256                               ventura:        "7ac7aab6e9336ed67c23226430fe0e5b0c7d44c407c93fc46e0be32e2c9456e2"
    sha256                               monterey:       "9e556fd1381362eecb2b551230de9a83dcbdd8eeabeae071c1852d25464079df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b40d07ee55ddc5088ce1f49b5972ccef7a3fd74fbaa872768f21c02855654aa"
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
