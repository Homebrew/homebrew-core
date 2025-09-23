class Cortexso < Formula
  desc "Drop-in, local AI alternative to the OpenAI stack"
  homepage "https://jan.ai/cortex"
  url "https://registry.npmjs.org/cortexso/-/cortexso-0.1.1.tgz"
  sha256 "48efc16761eebfdd60e50211049554e7b781b30e56461042c6bf100e84d8d244"
  license "Apache-2.0"
  head "https://github.com/janhq/cortex.git", branch: "dev"

  bottle do
    rebuild 2
    sha256                               arm64_tahoe:   "7c1735405ae8b08c0d395345a7ae8121a1e1669c955674a352352c54b981cadb"
    sha256                               arm64_sequoia: "fade5cc5bf426b17bf2f05dcd3e00d1973abff9916fdca7c1083f330a5354538"
    sha256                               arm64_sonoma:  "0c1084a5601dfc13ccd2aed4ab3ffbf0d3784f739e9b814ab6e22fda00a7ed1b"
    sha256                               arm64_ventura: "ea7343468eadc0574cb6ce2cf2b6614b8750a5977f9228ef3d1dd42a4e0b8641"
    sha256                               sonoma:        "b7e87930b4f4b3315d382bc46ca4c2207fe5b410c9054cee4e373f432738a7b3"
    sha256                               ventura:       "72e19258cda334b426b5fc40cddc58e7c184778c2e97c9f0f7636b1debe53e38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "386e435cfaf38bc9e5730faf70bf67ed64e9c4b3f208646b832e0d4082866bdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95cb135c5a9c3bc7194792b0dce8173b5bc261640f57ee4a8be05e31ec7cbfa3"
  end

  deprecate! date: "2025-07-19", because: :repo_archived

  depends_on "node"
  depends_on "sqlite" # needs sqlite3_enable_load_extension

  on_linux do
    # Workaround for old `node-gyp` that needs distutils.
    # TODO: Remove when `node-gyp` is v10+
    depends_on "python-setuptools" => :build
  end

  conflicts_with "cortex", because: "both install `cortex` binaries"

  def install
    system "npm", "install", "--sqlite=#{Formula["sqlite"].opt_prefix}", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace pre-built binaries
    rm_r(libexec/"lib/node_modules/cortexso/node_modules/cpu-instructions/prebuilds")
    cd libexec/"lib/node_modules/cortexso/node_modules/cpu-instructions" do
      system "npm", "run", "build"
      Pathname.glob("prebuilds/*/cpu-instructions.node").map { |f| f.rename(f.dirname/"cpuinfo.node") }
    end
  end

  test do
    port = free_port
    pid = fork { exec bin/"cortex", "serve", "--port", port.to_s }
    sleep 10
    sleep 10 if OS.mac? && Hardware::CPU.intel?
    begin
      assert_match "OK", shell_output("curl -s localhost:#{port}/v1/health")
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end
