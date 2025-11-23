class Monika < Formula
  desc "Synthetic monitoring made easy"
  homepage "https://monika.hyperjump.tech"
  url "https://registry.npmjs.org/@hyperjumptech/monika/-/monika-1.22.0.tgz"
  sha256 "2b2ed6ac3186d72a9f060efb62d183c4b156494b2c37de9808c108f54655b84c"
  license "MIT"
  revision 2

  bottle do
    sha256                               arm64_tahoe:   "7666c9d8ccb5caf33268ea57d5bc2bdfbf2ba02d535efcf8ea12cfcdf5f9c96d"
    sha256                               arm64_sequoia: "2accf99bc8d99d1d99fd923906461946b1840fbdeecf7263c1155e41ecd4fc87"
    sha256                               arm64_sonoma:  "23df655b1021663e0bc6184514c6f509ec1a492b5d8766f9d9b09b09375c9d35"
    sha256                               sonoma:        "fd2f4b9bf912a309be3a54757296966146450636de52de8426f4ca376dbd9a2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26485a9c9e463158a569f093f03eec4a3a2c614044ca23f736928f167e4184df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98229abf3b9246bf3478688d12018043004695ce89588260ddea3346b4f207fd"
  end

  depends_on "node"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version < 1700
  end

  on_linux do
    # Workaround for old `node-gyp` that needs distutils.
    # TODO: Remove when `node-gyp` is v10+
    depends_on "python-setuptools" => :build
  end

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version < 1700)

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
