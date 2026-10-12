class OpenScienceCli < Formula
  desc "AI research workbench for reproducible science"
  homepage "https://github.com/aipoch/open-science"
  url "https://github.com/aipoch/open-science/archive/refs/tags/v0.37.2.tar.gz"
  sha256 "a54aecd8536bc0135204c98f85b504008cb6e9fddcb6cf043ae0bee9fe3ad3bc"
  license "Apache-2.0"

  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
  depends_on "glib"
  depends_on "micromamba"
  depends_on "node"
  depends_on "vips"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "patchelf" => :build
    depends_on "dbus"
    depends_on "libsecret"
    depends_on "openssl@3"
  end

  # Sharp requires these headers when building against Homebrew vips.
  resource "node-addon-api" do
    url "https://registry.npmjs.org/node-addon-api/-/node-addon-api-8.9.2.tgz"
    sha256 "4cd65698541b19a33f798f1dc25c02c6ed1c9d7749b8824b1a1ccecdd197c8ea"
  end

  # The backend integration test listens on localhost.
  allow_network_access! :test

  def fetch
    # Download locked npm dependencies and Prisma engines before the offline build.
    system "npm", "ci", "--ignore-scripts", "--no-audit", "--no-fund"
    system "node", "node_modules/prisma/build/index.js", "generate"
  end

  def install
    ENV["npm_config_offline"] = "true"
    ENV["npm_config_nodedir"] = formula_opt_prefix("node")
    ENV["PYTHON"] = formula_opt_bin("python@3.14")/"python3.14"
    ENV["SHARP_FORCE_GLOBAL_LIBVIPS"] = "1"
    ENV["ELECTRON_SKIP_BINARY_DOWNLOAD"] = "1"
    ENV["PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD"] = "1"

    (buildpath/"node_modules/node-addon-api").install resource("node-addon-api")
    system "node", "scripts/prepare-shadcn-patch.mjs"
    system "node", "node_modules/patch-package/index.js", "--error-on-fail"
    system "node", "scripts/check-claude-acp-patch.mjs"
    system "npm", "run", "build:packages"

    %w[process-tree-native safe-file-publisher-native].each do |name|
      system "node", "node_modules/node-gyp/bin/node-gyp.js", "rebuild",
             "--directory", "packages/#{name}", "--nodedir=#{formula_opt_prefix("node")}"
    end

    # Sharp supports system vips; remove its bundled libraries and build its binding.
    rm_r(buildpath.glob("node_modules/@img/sharp-*"))
    cd "node_modules/sharp" do
      system "npm", "run", "build"
      rm_r((Pathname.pwd/"src/build/Release").children.reject { |path| path.extname == ".node" })
    end

    # Keep the locked Prisma, Canvas/Skia and ONNX native npm components coupled
    # to their JavaScript interfaces. Revisit these vendored components on every
    # release; upstream staging retains only the host platform.
    # Build the credential helpers locally; the npm wrapper downloads prebuilt components.
    system "node", "node_modules/node-gyp/bin/node-gyp.js", "rebuild",
           "--directory", "packages/credential-identity-probe-native",
           "--nodedir=#{formula_opt_prefix("node")}", "--", "-Dbuild_node_secret=1"
    system "node", "scripts/build-backend.mjs"
    system "npm", "run", "build:web:compiled"

    platform = OS.mac? ? "mac" : "linux"
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    (buildpath/"resources/bin"/platform/arch).mkpath
    ln_s formula_opt_bin("micromamba")/"micromamba", buildpath/"resources/bin"/platform/arch/"micromamba"
    system "node", "scripts/stage-backend.mjs"
    libexec.install (buildpath/"out/standalone").children
    if OS.linux?
      # Homebrew uses glibc; the optional musl Canvas binary is not loadable here.
      rm_r libexec/"node_modules/@napi-rs/canvas-linux-#{arch}-musl"

      # Staging moves Prisma out of the hidden node_modules/.prisma directory.
      engines = libexec.glob("resources/prisma-client/libquery_engine-*.so.node")
      raise "No staged Prisma engine found" if engines.empty?

      # The released Prisma engines link to OpenSSL 3, independently of Node's OpenSSL.
      engines.each do |engine|
        system "patchelf", "--add-rpath", formula_opt_lib("openssl@3"), engine
      end
    end
    (bin/"open-science").write_env_script formula_opt_bin("node")/"node", libexec/"cli.mjs", {}
  end

  service do
    run [formula_opt_bin("node")/"node", opt_libexec/"out/backend/index.cjs", "--serve=44100"]
    environment_variables PATH: std_service_path_env
    keep_alive successful_exit: false
    log_path var/"log/open-science.log"
    error_log_path var/"log/open-science.log"
  end

  test do
    ENV["OPEN_SCIENCE_CONFIG_ROOT"] = testpath/"profile"
    ENV["OPEN_SCIENCE_WEB_PORT"] = "0"
    initialized = JSON.parse(shell_output("#{bin}/open-science init --json"))
    assert_equal (testpath/"profile").to_s, initialized.fetch("configRoot")
    assert initialized.fetch("initialized")
    assert_path_exists testpath/"profile"
    assert_equal({ "running" => false }, JSON.parse(shell_output("#{bin}/open-science status --json", 1)))

    # Exercise the shipped database engine and image bindings without using an OS keychain.
    (testpath/"native.cjs").write <<~JS
      const assert = require('node:assert/strict');
      const { createRequire } = require('node:module');
      const requireInstalled = createRequire('#{libexec}/package.json');
      const { PrismaClient } = requireInstalled('@prisma/client');
      const { createCanvas } = requireInstalled('@napi-rs/canvas');
      const sharp = requireInstalled('sharp');
      requireInstalled('@aipoch/process-tree-native');
      requireInstalled('@aipoch/safe-file-publisher-native');
      (async () => {
        const db = new PrismaClient({datasources: {db: {url: 'file:#{testpath}/test.db'}}});
        try {
          const result = await db.$queryRawUnsafe('SELECT 42 AS answer');
          assert.equal(Number(result[0].answer), 42);
        } finally {
          await db.$disconnect();
        }
        const canvas = createCanvas(16, 16);
        canvas.getContext('2d').fillRect(0, 0, 16, 16);
        const image = await sharp(canvas.toBuffer('image/png')).resize(8, 8).png().toBuffer();
        const metadata = await sharp(image).metadata();
        assert.equal(metadata.width, 8);
        assert.equal(metadata.height, 8);
      })().catch(error => { console.error(error); process.exitCode = 1; });
    JS
    system formula_opt_bin("node")/"node", testpath/"native.cjs"

    require "utils/linkage"
    sharp = libexec.glob("node_modules/sharp/src/build/Release/sharp-*.node").first
    libvips = formula_opt_lib("vips")/shared_library("libvips")
    assert sharp && Utils.binary_linked_to_library?(sharp, libvips), "Sharp must link to Homebrew vips"

    return unless OS.linux?

    begin
      system bin/"open-science", "start", "--no-open", "--credential-store=file"
      project = JSON.parse(shell_output("#{bin}/open-science project create 'Homebrew test' --json"))
      assert_equal "Homebrew test", project.fetch("name")
      assert_predicate project.fetch("id"), :present?
    ensure
      system bin/"open-science", "stop"
    end
  end
end
