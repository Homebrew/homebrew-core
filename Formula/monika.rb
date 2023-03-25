require "language/node"

class Monika < Formula
  desc "Synthetic monitoring made easy"
  homepage "https://monika.hyperjump.tech"
  url "https://registry.npmjs.org/@hyperjumptech/monika/-/monika-1.15.1.tgz"
  sha256 "43cf75f0d5ecffb483b9431c57b1c5b887ae3ceb11e24d316c6338556dbac4d9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11e2313387efa31bfb5cb7d8d5832efbbda77a4a5ee4f1520a62620acca05c34"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2b8464da0ee50ec4f243436d22912cfa6bf3c28ad11d00d63651e6d723c4537"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "beeb355ff120753f42cdbe9d8e8c936c6430c7480ff0c6893a172a8c299d1e8f"
    sha256 cellar: :any_skip_relocation, ventura:        "dadf05b490b82f07d045567b44ca17dfc58898a13b58f00a9b035b515993ddf5"
    sha256 cellar: :any_skip_relocation, monterey:       "4ddc049e9909efd8eb6f7bfb071e27c2fb7c7a33675711f16f6cefd3c388aea1"
    sha256 cellar: :any_skip_relocation, big_sur:        "c3c093e3069f33ec5a461af7037dabf50344dc2c7a4bba9e483299644b391abf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7623fb89f8f00ec42cdb0d8f08a18696a913786d4501e38e983526a76473698"
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
