class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.21.0.tgz"
  sha256 "745493fcc96a88ea9a1b6fb0271b4fbd4c302bbda2c51dd709548d08e0da9b66"
  license "GPL-3.0-or-later"

  bottle do
    manifest_sha256 "1a90b27dfb56004d443c6a8fa0392b68cae84153da7f79ebe4da4659152c43e5"
    sha256 cellar: :any, arm64_golden_gate: "93d32dd206df27bfeead3eb168ba770fc644a7a32e2cea321a5ff1218652f33b"
    sha256 cellar: :any, arm64_tahoe:       "af72c91f7926213c1ba30cb294254ed6649f2450c42edf9f7d650319c8dd8aa3"
    sha256 cellar: :any, arm64_sequoia:     "98f8377f27251473f88ef07c7109618d599b88495c5875c5418286ce7c95efc0"
    sha256 cellar: :any, arm64_linux:       "e604d20314826128ad2a5e87c01d08c79960879d484b1f8a586ea65f08955a6f"
    sha256 cellar: :any, x86_64_linux:      "be47776c03ef87ef076a6f7a16268a2aa5e349617514c6318fff1e43ed4c39c3"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "node"
  depends_on "pnpm"
  depends_on "rust"
  depends_on "vips"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "patchelf" => :build
    depends_on "xz"
  end

  # Resources needed to build sharp from source to avoid bundled vips
  # https://sharp.pixelplumbing.com/install/#building-from-source
  resource "node-addon-api" do
    url "https://registry.npmjs.org/node-addon-api/-/node-addon-api-8.9.2.tgz"
    sha256 "4cd65698541b19a33f798f1dc25c02c6ed1c9d7749b8824b1a1ccecdd197c8ea"
  end

  resource "node-gyp" do
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-13.1.0.tgz"
    sha256 "15663ca4944844139023390f057e86f1897d855959ea7e96f151d4873be8c71f"
  end

  def install
    system "npm", "install", *std_npm_args, *resources.map(&:cached_download)
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/pake-cli/node_modules"
    libexec.glob("#{node_modules}/.pnpm/fsevents@*/node_modules/fsevents/fsevents.node").each do |f|
      deuniversalize_machos f
    end

    # Help the prebuilt `@tauri-apps/cli` module find Homebrew's `liblzma`.
    if OS.linux?
      node_modules.glob("@tauri-apps/cli-linux-*/cli.linux-*.node").each do |f|
        system "patchelf", "--set-rpath", formula_opt_lib("xz"), f
      end
    end

    ENV["SHARP_FORCE_GLOBAL_LIBVIPS"] = "1"

    # `sharp` ships prebuilds whose bundled `vips` shares the brewed soname
    rm_r(node_modules.glob("@img/sharp-*/lib/*.node"))
    rm_r(node_modules.glob("@img/sharp-libvips-*/lib/libvips-cpp.*"))
    cd node_modules/"sharp" do
      system "npm", "run", "build"
      rm_r("src/build/Release/obj.target")
    end
  end

  test do
    require "expect"
    assert_match version.to_s, shell_output("#{bin}/pake --version")

    (testpath/"index.html").write <<~HTML
      <h1>Hello, World!</h1>
    HTML

    # `brew test` runs with the keg read-only, but Pake creates its build cache
    # lock in Cargo's target directory before it does anything else.
    ENV["CARGO_TARGET_DIR"] = testpath/"target"

    begin
      io = IO.popen("#{bin}/pake index.html --use-local-file --iterative-build --name test")
      sleep 5
    ensure
      Process.kill("TERM", io.pid)
      Process.wait(io.pid)
    end

    assert_match "No icon provided, using default icon.", io.read
  end
end
