class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.20.0.tgz"
  sha256 "58b471f6870c3616f2db2182a14e023003a674eb1db7eb152c18856ff49fd75c"
  license "GPL-3.0-or-later"

  bottle do
    manifest_sha256 "fd300287ab454ee388abb8bb2977187d6cdf8980f1b046ac0db1a22a1c1e13fe"
    sha256 cellar: :any, arm64_golden_gate: "1e2fa924600d29ed8b86c336a19fee258cee9d9743999588e149923a96d7557e"
    sha256 cellar: :any, arm64_tahoe:       "2c58d7b690ae39c18d5e4bc63ab755ba63e20abd9856c8014a29aea40a752c09"
    sha256 cellar: :any, arm64_sequoia:     "0f7a40bcd2132563a403b487bd6f69280595ac5f470456bf20b660a8b2122f14"
    sha256 cellar: :any, arm64_linux:       "7bb47336cc86acf06a3797f7f2fcd8cafcb332e1d335bc26b6b298b89aacada1"
    sha256 cellar: :any, x86_64_linux:      "142984437de07c14f1845f9c7e0fb88cc8d8ccd64f4291c00492845e137328a5"
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
