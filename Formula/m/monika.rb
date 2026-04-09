class Monika < Formula
  desc "Synthetic monitoring made easy"
  homepage "https://monika.hyperjump.tech"
  url "https://registry.npmjs.org/@hyperjumptech/monika/-/monika-1.22.0.tgz"
  sha256 "2b2ed6ac3186d72a9f060efb62d183c4b156494b2c37de9808c108f54655b84c"
  license "MIT"
  revision 2

  bottle do
    rebuild 1
    sha256                               arm64_tahoe:   "8758ea33703b5c0c17a2761f32c97f0deb21c08c6795eee47de06031645110e4"
    sha256                               arm64_sequoia: "64bd0c4aa6bfa2b191d6e1442b248430462730b10be45546714d27eb7606898a"
    sha256                               arm64_sonoma:  "208e46a9f034bedac3d0a7bac2c68a18ee61cd3321aeff25dfdf556ff5d63612"
    sha256                               sonoma:        "53f106ddd400e9dc86a2d2071c01415593c6fd3d7aa13a8e010af483a94a43aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "73017a52b8cc391a457495015cdea44011d82bdb362618cd5c305c55a65f5ed5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b93ff991a39a3eb117d3a95d4acc8b1f05d6ab02445ee6dd6da0bb697fbc8370"
  end

  depends_on "rust" => :build
  depends_on "node@24" # node 25+ fails with Clang < 1700. LLVM Clang fails on node-addon-api@^4.2.0
  depends_on "sqlite"

  on_linux do
    # Workaround for old `node-gyp` that needs distutils.
    # TODO: Remove when `node-gyp` is v10+
    depends_on "python-setuptools" => :build
  end

  resource "@napi-rs/nice" do
    url "https://github.com/Brooooooklyn/nice/archive/refs/tags/v1.1.1.tar.gz"
    sha256 "d6570f64e2efa79d5bbeb6765b2ad42f41e732e900e5668f5336d5033f250137"

    livecheck do
      url "https://registry.npmjs.org/@napi-rs/nice/latest"
      strategy :json do |json|
        json["version"]
      end
    end
  end

  def install
    system "npm", "install", "--sqlite=#{Formula["sqlite"].opt_prefix}", *std_npm_args(ignore_scripts: false)
    bin.install_symlink libexec.glob("bin/*")

    # Replace pre-built binaries
    node_modules = libexec/"lib/node_modules/@hyperjumptech/monika/node_modules"
    resource("@napi-rs/nice").stage do
      system "npm", "install", *std_npm_args(prefix: false)
      system "npm", "run", "build"
      (node_modules/"@napi-rs/nice").install Dir["nice.*.node"]
      rm_r(node_modules.glob("@napi-rs/nice-*"))
    end

    cd node_modules/"@sentry/profiling-node" do
      rm(Dir["lib/sentry_cpu_profiler*.node"])
      system "npm", "run", "build:bindings:configure"
      system "npm", "run", "build:bindings"
    end
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
