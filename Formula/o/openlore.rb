class Openlore < Formula
  desc "Persistent architectural memory and structural cognition for AI coding agents"
  homepage "https://github.com/clay-good/OpenLore"
  url "https://registry.npmjs.org/openlore/-/openlore-3.6.0.tgz"
  sha256 "ad55736e5d6bcbd5dcaaec6bca4c9d62ca062dd8ae99402d3cc2c92a92de3be9"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "264b4952b30f3839d944d770542e8d36ff0b37db37ed910cdc776e663748363d"
    sha256 cellar: :any, arm64_tahoe:       "0dd1feaecb4ea0dca3dfd218ace7297c692e39ec85c7790c75fef127c39e8b5a"
    sha256 cellar: :any, arm64_sequoia:     "9e89ecd80d7503a3329a932b24b4dfd7a266a9dc2127db1ec6e5336d00b45f0d"
    sha256 cellar: :any, arm64_linux:       "14ec14222c8c195e90bbf0bbdfc8dcbe6e3a6a9c6961664bbe62df9607727a6f"
    sha256 cellar: :any, x86_64_linux:      "d382b1104c2dd5433afa72a99b7e2c577fb2bbc85f2ab3625e96a12e9942de35"
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
