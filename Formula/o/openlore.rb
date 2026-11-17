class Openlore < Formula
  desc "Persistent architectural memory and structural cognition for AI coding agents"
  homepage "https://github.com/clay-good/OpenLore"
  url "https://registry.npmjs.org/openlore/-/openlore-3.7.0.tgz"
  sha256 "56c77ac468a476e33586f51dbb931f619286a35113b1fcd7ed961457a53f12ea"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "138ec6a3faaf9a3aeb96b56efa71964643a5e62ca35fdd682b2692b2136257dd"
    sha256 cellar: :any, arm64_tahoe:       "c418e2a79135f7095b2e1d9570ecc8eb14ae4b031d0afb6ff09b4dd14a36052f"
    sha256 cellar: :any, arm64_sequoia:     "5b2508bfee21c7c57a0e6011e1b5bea96746f9bbc44e299c83f69ddee2b33a5b"
    sha256 cellar: :any, arm64_linux:       "0a7632446f5ac77ed0bd766e2fa14c148f1ae2f2b0c01e2dfc7d06968cdcc88f"
    sha256 cellar: :any, x86_64_linux:      "dafb9c78c714d717f7698d5c00db94a373df7c8d4bb7ad90afc7ce9ef1a631d4"
  end

  depends_on "node"

  on_macos do
    depends_on arch: :arm64 # missing `onnxruntime` prebuilt binaries
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/openlore/node_modules"
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : "arm64"

    # Prebuilds are unreliable (x86_64 mislabeled as linux-arm64); rebuild from source
    inreplace node_modules/"tree-sitter/binding.gyp", "c++17", "c++20" # node 26 headers require C++20
    rm_r node_modules.glob("**/prebuilds")
    ENV["npm_config_nodedir"] = formula_opt_prefix("node")
    cd libexec/"lib/node_modules/openlore" do
      node_modules.glob("{*,*/node_modules/*}/binding.gyp")
                  .each { |gyp| system "npm", "rebuild", gyp.parent.basename.to_s }
    end

    # Keep only the native `onnxruntime-node` binaries, which `@lancedb/lancedb` also nests
    node_modules.glob("**/onnxruntime-node/bin/*/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != os }
    node_modules.glob("**/onnxruntime-node/bin/*/*/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != arch }

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openlore --version")
    assert_match "<!-- BEGIN OPENLORE", shell_output("#{bin}/openlore install --dry-run 2>&1")
    assert_match "Node.js version", shell_output("#{bin}/openlore doctor")

    node_modules = libexec/"lib/node_modules/openlore/node_modules"
    system formula_opt_bin("node")/"node", "-e",
           "require('#{node_modules}/tree-sitter'); require('#{node_modules}/onnxruntime-node')"

    (testpath/"test.ts").write("function foo() { bar(); } function bar() {}")
    assert_match "Initialization Complete", shell_output("yes | #{bin}/openlore init")
    assert_match "Ready for generation!", shell_output("#{bin}/openlore analyze")
    # call-graph nodes only appear when the native parser loaded
    assert_match "test.ts::foo", (testpath/".openlore/analysis/llm-context.json").read
  end
end
