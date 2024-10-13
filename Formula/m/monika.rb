class Monika < Formula
  desc "Synthetic monitoring made easy"
  homepage "https://monika.hyperjump.tech"
  url "https://registry.npmjs.org/@hyperjumptech/monika/-/monika-1.21.0.tgz"
  sha256 "b265ffce61fde24aaf51e6c84e30d158e3555474683598809d1174e768d61752"
  license "MIT"

  bottle do
    rebuild 1
    sha256                               arm64_sequoia:  "7479124ad18ecf3c9ed273cae783fc4c3a7ffa9077418fa218b29c365820e4c2"
    sha256                               arm64_sonoma:   "8d3b69446254d8e0d9667e7b08c6815357804538de8e91f3010829a3fde152e3"
    sha256                               arm64_ventura:  "df4846dbe84f5ec928764cad0f39a02c01ed08cb914a34e03d0a511e914c4868"
    sha256                               arm64_monterey: "191f1690fa6e465e29be220ca4ddc6da8edca36207e833ee77de90de725475d5"
    sha256                               sonoma:         "138479415075dfac8741f4c153b4b3627715a436568746cb565bbbbab2f4f850"
    sha256                               ventura:        "4a9ca5e23f852102f51d0c8850fa251d100674683aaafb4ee557cc5a287b8a66"
    sha256                               monterey:       "70805c46425cfa7e0db73f712477f510f093e8f0cb3d435f83480a2c32786060"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a71a527a6c518e829349b096c452213f5d4c41596c3ae28ffba0f94e9a5187b"
  end

  depends_on "node"

  on_linux do
    # Workaround for old `node-gyp` that needs distutils.
    # TODO: Remove when `node-gyp` is v10+
    depends_on "python-setuptools" => :build
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@hyperjumptech/monika/node_modules"
    node_modules.glob("nice-napi/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

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
