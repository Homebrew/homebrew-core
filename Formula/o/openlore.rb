class Openlore < Formula
  desc "Persistent architectural memory and structural cognition for AI coding agents"
  homepage "https://github.com/clay-good/OpenLore"
  url "https://registry.npmjs.org/openlore/-/openlore-3.8.0.tgz"
  sha256 "9f09760d473483a7eb06dba327d5ea1872bdb6af080e72c32216f2b7f8ace142"
  license "MIT"

  bottle do
    manifest_sha256 "e9e0392f73d2b2e6c0547e191548d6365cfb8c8afe05091ac5753251273d1dae"
    sha256 cellar: :any, arm64_golden_gate: "41a19691657b61fc2e7f081f60ab38cf975606a279f86baa919323c45b58c502"
    sha256 cellar: :any, arm64_tahoe:       "93d51d3baaf9d6f7199a3c11e5b5ebfbf8ed8e8aa51967024b7a9333a648d4de"
    sha256 cellar: :any, arm64_sequoia:     "d8cc5c66933eb72b04bcef26cc6dded7df031c04f966814b48fd4323bae591ef"
    sha256 cellar: :any, arm64_linux:       "7097aee89cd379cade5327dd77067b8ae00df18a474a69a1df2ddd21e3bd9791"
    sha256 cellar: :any, x86_64_linux:      "706b0e891152da48b818e81d2a61168e7b370d97bfaea37adadd5cae1d248b21"
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
