class Monika < Formula
  desc "Synthetic monitoring made easy"
  homepage "https://monika.hyperjump.tech"
  url "https://registry.npmjs.org/@hyperjumptech/monika/-/monika-1.22.0.tgz"
  sha256 "2b2ed6ac3186d72a9f060efb62d183c4b156494b2c37de9808c108f54655b84c"
  license "MIT"
  revision 1

  bottle do
    sha256                               arm64_sequoia: "f3e91a0c2e44a73268d2ad097f66b186d557e7c29bd6cc9bfbf5cdf6f83a51a4"
    sha256                               arm64_sonoma:  "f2ae79c53a534008b89160ae1c8ae3fdda47aee6fc61218267468b19836a2369"
    sha256                               arm64_ventura: "1a4b455c1dff23c63b60585ddfe58e19f9028fca8b7ebf5f48b63d2a83fca64b"
    sha256                               sonoma:        "4ebb6355f4ed47cd9c1e85566eed9c2836b710bb5f79a6160ed7449d6217902b"
    sha256                               ventura:       "ed6f5ea7a08fc1201b8e41b4172caf6bfaba98c1ddc7fce30c288516fe3e9f26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ddaf84cdd4938c7a6884cad00e978282ba40458b44714405566a90bd9b412e41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e525f7478ff11969327f3a1a65e22bb296716c68a3ef064196029f816e19e4c"
  end

  depends_on "node"

  on_linux do
    # Workaround for old `node-gyp` that needs distutils.
    # TODO: Remove when `node-gyp` is v10+
    depends_on "python-setuptools" => :build
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@hyperjumptech/monika/node_modules"
    node_modules.glob("nice-napi/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    cpu_profiler = "@sentry/profiling-node/lib/sentry_cpu_profiler"
    node_modules.glob("#{cpu_profiler}-*")
                .each { |file| rm(file) unless file.basename.to_s.start_with?("sentry_cpu_profiler-#{os}-#{arch}") }
    node_modules.glob("#{cpu_profiler}-*-musl-*").map(&:unlink) if OS.linux?
  end

  test do
    (testpath/"config.yml").write <<~YAML
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
    YAML

    monika_stdout = (testpath/"monika.log")
    fork do
      $stdout.reopen(monika_stdout)
      exec bin/"monika", "-r", "1", "-c", testpath/"config.yml"
    end
    sleep 15
    sleep 15 if OS.mac? && Hardware::CPU.intel?

    assert_match "Starting Monika. Probes: 1. Notifications: 1", monika_stdout.read
  end
end
