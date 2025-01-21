class Monika < Formula
  desc "Synthetic monitoring made easy"
  homepage "https://monika.hyperjump.tech"
  url "https://registry.npmjs.org/@hyperjumptech/monika/-/monika-1.21.2.tgz"
  sha256 "a9280ac4c288a79c77c28263042fab1d4cc785ef08f94d0cfd3cb25b7e40dce4"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "cf7bd831f3b50b22b53a45be3fc9468fd3449e77d16ecc6a14a7fc91a0c2048e"
    sha256                               arm64_sonoma:  "02f1de44e451e3bf0595b7d12f1905534d9bbb377e062c61828221464f41b370"
    sha256                               arm64_ventura: "ee92b0a0707890c6ec213c46e5d2f4812ba1fc4a867eb82129c8e1a8cbb1f95f"
    sha256                               sonoma:        "d7a43499c51096dbfb3c6e75ff208c97f56a455f8280d24d64e99a8e17f959dd"
    sha256                               ventura:       "e29d95f54d6d00802440e3531649ac1253ba2a4843e029cb61f10d7badfb3753"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad68335a7a0fad36f34fa12a266e997cbc583f6ade8c160bc70278bf6e3f82ca"
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
