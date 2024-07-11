require "language/node"

class Cortexso < Formula
  desc "Drop-in, local AI alternative to the OpenAI stack"
  homepage "https://jan.ai/cortex"
  url "https://registry.npmjs.org/cortexso/-/cortexso-0.1.6.tgz"
  sha256 "50f16c355957df7e67321fd2f41ed8804706927611fd70418ebd11f7f8a6336c"
  license "Apache-2.0"
  head "https://github.com/janhq/cortex.git", branch: "dev"

  bottle do
    sha256                               arm64_sonoma:   "949ddfffd7080fd4784d41336a04f9d5563ce6d36e0603c5afb7c3cceaf82f1a"
    sha256                               arm64_ventura:  "343b1cf9fa6816b06ff85c3baff74c9f97ac667fbcc221e5161fb2608765914b"
    sha256                               arm64_monterey: "c0d0a6f242e4bb9863fc9bc2df0770996945144b544b71b1dfd33bad388d589a"
    sha256                               sonoma:         "e9374a6c7f5f98fa106a64917bc7d0d266a225f20613d1885215cf4d4723d9b2"
    sha256                               ventura:        "4ce108f4edbdd437d5136e85497ab8e90dd0caf4d491db970c4e3e36512f10a6"
    sha256                               monterey:       "d31c77f913d8af0fc3eeee913b293f63242a5bcad0399d2e8a7e2039bb9308cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68a5b223387791ba534e7c06126c8938c62bc898176585d0d27755d575445696"
  end

  depends_on "cmake" => :build
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
    node_modules = libexec/"lib/node_modules/cortexso/node_modules/cpu-instructions/prebuilds"
    node_modules.each_child do |dir|
      dir.rmtree if dir.basename.to_s != "#{os}-#{arch}"
    end
  end

  test do
    port = free_port
    pid = fork { exec bin/"cortex", "serve", "--port", port.to_s }
    sleep 10
    begin
      assert_match "OK", shell_output("curl -s localhost:#{port}/v1/health")
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end
