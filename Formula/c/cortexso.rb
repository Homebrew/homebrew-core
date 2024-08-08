class Cortexso < Formula
  desc "Drop-in, local AI alternative to the OpenAI stack"
  homepage "https://jan.ai/cortex"
  url "https://registry.npmjs.org/cortexso/-/cortexso-0.5.0-37.tgz"
  sha256 "883798e0e252cc5bc43851570d66dac9f6e31143f5ed4ea690f26508ec7a1523"
  license "Apache-2.0"
  head "https://github.com/janhq/cortex.git", branch: "dev"

  bottle do
    rebuild 1
    sha256                               arm64_sonoma:   "5a40692000193b98c8274e0f4b6cd366558fc464e91fbc9222af2e16b4238b2b"
    sha256                               arm64_ventura:  "e505143e5417668b3027c83e923871bacbbaf5ac0a86bde0e0b156bfad7e0c36"
    sha256                               arm64_monterey: "0d30abe3e770dc4596348ba52c39bdeadbc270d61213a563c8f655c694858362"
    sha256                               sonoma:         "33d3271364280efa43bdf39ff61532e4e6f1ec5e1d0a2c3e9c70695cd6f5977f"
    sha256                               ventura:        "9dc575f5fcdb463e7fd8e00159329fe29080b76e3c563de647c90b2affaf9141"
    sha256                               monterey:       "30aa7c29ce75ef1429af1393073d4970a6b101bad2ddc638164e9b22cbb6b54e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f02d924016dcab7dce2faecaac5a77ba04ad4ba20dcac3e0fcc753d248364264"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "yarn" => :build
  depends_on "node"

  on_linux do
    # Workaround for old `node-gyp` that needs distutils.
    # TODO: Remove when `node-gyp` is v10+
    depends_on "python-setuptools" => :build
    depends_on "util-linux" # for libuuid
    depends_on "zlib"
  end

  conflicts_with "cortex", because: "both install `cortex` binaries"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/cortexso/node_modules/cpu-instructions/prebuilds"
    node_modules.each_child do |dir|
      rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}"
    end
    # Remove build dependencies
    rm_r("#{libexec}/lib/node_modules/cortexso/node_modules/cortex-cpp/build-deps/cortex-cpp-deps")
    rm_r("#{libexec}/lib/node_modules/cortexso/node_modules/cortex-cpp/build/CMakeCache.txt")
    rm_r("#{libexec}/lib/node_modules/cortexso/node_modules/cortex-cpp/build/CMakeFiles")
    rm_r("#{libexec}/lib/node_modules/cortexso/node_modules/cortex-cpp/build/compile_commands.json")
  end

  test do
    port = free_port
    pid = fork { exec bin/"cortex", "--port", port.to_s }
    sleep 10
    begin
      assert_match "OK", shell_output("curl -s localhost:#{port}/v1/system")
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end
