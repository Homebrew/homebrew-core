class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.19.6.tgz"
  sha256 "8461c689f02b3e71fd2c59c4f34106bb5507f571e1345740c2ecc5d03b148c88"
  license "GPL-3.0-or-later"

  bottle do
    manifest_sha256 "6ef435055cb9e7f1c862ce8ef43adb54bd72be2818695f5d777b365ef1267ada"
    sha256 cellar: :any, arm64_golden_gate: "326b19b6708ad2ea024882b56bd0b914c12e24f2f8e0e909365c2cbcdc6d87cf"
    sha256 cellar: :any, arm64_tahoe:       "4a35b24ecf473a005c01499f8a17817f07d0fc8caaba76d1ee7bc70cf0084864"
    sha256 cellar: :any, arm64_sequoia:     "fd13b57f4a6e196f91fbe2002fbd92bbd25498275f21235604a6d52c26cf9c7a"
    sha256 cellar: :any, arm64_linux:       "55998c38419a14ceaf00d5385f9f6a1dc43431cb641cb2a6835c6c9b6da530db"
    sha256 cellar: :any, x86_64_linux:      "3d05772638c93118a751b0181c4a4c169d8bddd000eff39be0b74a68193a469a"
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
