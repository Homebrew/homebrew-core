class DeepseekHarness < Formula
  desc "Composable agent harness where everything is a plugin"
  homepage "https://github.com/deepseek-ai/deepseek-harness"
  url "https://registry.npmjs.org/@deepseek-ai/dsh/-/dsh-0.1.0-rc.6.tgz"
  sha256 "1b8a9a0ad3c7feaece47926e0bd37ca151c7ccfa997953afa5fd01261784eadc"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/@deepseek-ai/dsh/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "node"
  depends_on "pnpm"
  depends_on "vips"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "python@3.14" => :build
  end

  conflicts_with "dsh", because: "both install a `dsh` executable"

  # Resources needed to build sharp from source to avoid bundled vips
  # https://sharp.pixelplumbing.com/install/#building-from-source
  resource "node-addon-api" do
    url "https://registry.npmjs.org/node-addon-api/-/node-addon-api-8.9.2.tgz"
    sha256 "4cd65698541b19a33f798f1dc25c02c6ed1c9d7749b8824b1a1ccecdd197c8ea"
  end

  resource "node-gyp" do
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-13.0.1.tgz"
    sha256 "455327cde805c299d5a16603419e106853db5b9257dfb85e44eb7f4ec4d99de5"
  end

  def install
    # The CLI and its first-party plugin packages are released together.
    # Keep Homebrew's release cooldown for all other npm dependencies.
    ENV["SHARP_FORCE_GLOBAL_LIBVIPS"] = "1"
    system "npm", "install", *std_npm_args(ignore_scripts: false),
           *resources.map(&:cached_download),
           "--min-release-age-exclude=@deepseek-ai/*"
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@deepseek-ai/dsh/node_modules"
    rm_r node_modules/"node-pty/third_party"
    rm_r(node_modules.glob("@koromix/koffi-linux-*/musl_*"))

    # Replace sharp pre-built binaries and their bundled libvips.
    rm_r(node_modules.glob("@img/sharp-*"))
    cd node_modules/"sharp" do
      system "npm", "run", "build"
      rm_r("src/build/Release/obj.target")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dsh --version")
    assert_match "boot a DeepSeek Harness profile", shell_output("#{bin}/dsh --help")

    node_pty = libexec/"lib/node_modules/@deepseek-ai/dsh/node_modules/node-pty"
    (testpath/"pty-test.cjs").write <<~JAVASCRIPT
      const pty = require(#{node_pty.to_s.dump});
      const child = pty.spawn("/bin/sh", ["-c", "printf dsh-pty-ok"]);
      let output = "";
      child.onData(data => output += data);
      child.onExit(({ exitCode }) => {
        process.stdout.write(output);
        process.exit(exitCode);
      });
    JAVASCRIPT
    assert_match "dsh-pty-ok", shell_output("#{formula_opt_bin("node")}/node pty-test.cjs")

    (testpath/"native-modules-test.cjs").write <<~JAVASCRIPT
      require(#{(node_pty.parent/"koffi").to_s.dump});
      require(#{(node_pty.parent/"sharp").to_s.dump});
      require(#{(node_pty.parent/"node-addon-require-builtin").to_s.dump});
    JAVASCRIPT
    system formula_opt_bin("node")/"node", "native-modules-test.cjs"

    require "utils/linkage"
    sharp = libexec.glob("lib/node_modules/@deepseek-ai/dsh/node_modules/sharp/src/build/Release/sharp-*.node").first
    libvips = formula_opt_lib("vips")/shared_library("libvips")
    assert sharp && Utils.binary_linked_to_library?(sharp, libvips),
           "No linkage with #{libvips.basename}! Sharp is likely using a prebuilt version."

    ENV["DSH_HOME"] = testpath
    output = shell_output("#{bin}/dsh plugin --profile test --version 2>&1")
    assert_match Formula["pnpm"].version.to_s, output
    assert_path_exists testpath/"profiles/test/package.json"
  end
end
