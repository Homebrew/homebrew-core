class Monika < Formula
  desc "Synthetic monitoring made easy"
  homepage "https://monika.hyperjump.tech"
  url "https://registry.npmjs.org/@hyperjumptech/monika/-/monika-1.22.0.tgz"
  sha256 "2b2ed6ac3186d72a9f060efb62d183c4b156494b2c37de9808c108f54655b84c"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "b454a3a9c3ab9b5ae518e59e49ffa26ef65cf251158612f1bf035de1d8a94e73"
    sha256                               arm64_sonoma:  "dbb6ee7aad6c0737edfcdb194fb4c198b9314ad759a3c09136cd5a934da61fe4"
    sha256                               arm64_ventura: "432a1fa231644bc3afab36e6b57c1103a7763bbb4c32e308edb9f83adffa7541"
    sha256                               sonoma:        "6d1e3680020b3fb8fabd44383bd2ef3d802742142781bac50f3602ab527932c7"
    sha256                               ventura:       "36ff8854590a71d7ada5d70fbcbe314c1d8259a830fac7f86a06bff3427798a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "678bacbee424d600e2dfb41f6d45bb8ead8086cebd1fe94ab578614030943f7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a1daac5d355750602a48ef01fcc34867c21ce4a725659e431f94f277ac818ff"
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
