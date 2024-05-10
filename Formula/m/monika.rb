require "language/node"

class Monika < Formula
  desc "Synthetic monitoring made easy"
  homepage "https://monika.hyperjump.tech"
  url "https://registry.npmjs.org/@hyperjumptech/monika/-/monika-1.20.1.tgz"
  sha256 "93b0e0a76e5eee464d56f8f578db1851c4985a50de2b4c189ba4ee21c1ce03ad"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "964e7777028e713b9b9b2a71a8b325bfbb594e965637b3d279a5d4a97f39c530"
    sha256                               arm64_ventura:  "4283f9c2f7e268c2ae69c054eb764b9b62a11c52fe6ae06960062c01fdb17406"
    sha256                               arm64_monterey: "457107c2ad71876d3cc598ed016b4aebbfc96c38df1cee39c10ef6d09cc879f8"
    sha256                               sonoma:         "c2af6850ff8dc7c972aca624b87a8ef265e69b6fedf30eaf8ab446a096d623e5"
    sha256                               ventura:        "2242b0dd6b66745e175f619f838f30250ac39fa0842cb28134a748b894868799"
    sha256                               monterey:       "86e21db45a9d0b8222b867895705c07937698fb415388bbbbcf5ddff681c2e9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2639ed8f2d67ce836fc28451392208456440365a66721ace4bc7c1d8ff37125d"
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
