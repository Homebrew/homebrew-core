class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.12.1.tgz"
  sha256 "19b24005c5f8465ddc30e1c31c3d623244b33f866b90e29b4a4e5b62e8857ff8"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "67a0a630a1ea331c340c29b4b51a5e889e25d0db9e57195e8653ce58fb2e8ace"
    sha256 cellar: :any, arm64_sequoia: "fc1291c0fdc3fe883c248ea0c7a97f497c5b84a757dbc82d09ad3e6ca9ea9564"
    sha256 cellar: :any, arm64_sonoma:  "fc1291c0fdc3fe883c248ea0c7a97f497c5b84a757dbc82d09ad3e6ca9ea9564"
    sha256 cellar: :any, sonoma:        "fb194727822600f7a7b232c165f3ddb731504866664c2d9bc9088833a19124d6"
    sha256 cellar: :any, arm64_linux:   "2e987ce232ca2a6f91d61af7d266a1e8d059ee18cf2f259808189b3bae7dc06e"
    sha256 cellar: :any, x86_64_linux:  "2deeb09dd6209d28af83ffbe1ac65568c3855e61f2681ff2ee49e4283df54359"
  end

  depends_on "node"
  depends_on "pnpm"
  depends_on "rust"
  depends_on "vips"

  # Resources needed to build sharp from source to avoid bundled vips
  # https://sharp.pixelplumbing.com/install/#building-from-source
  resource "node-addon-api" do
    url "https://registry.npmjs.org/node-addon-api/-/node-addon-api-8.8.0.tgz"
    sha256 "72528f1a8235a8bc19855e21cc5ae28252c276338afa73887dc7e54515bc76c5"
  end

  resource "node-gyp" do
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-13.0.0.tgz"
    sha256 "10e45f33997680c9ea6ebfb8c575aba66bfbe8ad9c782a7426a37440b28b62a6"
  end

  def install
    ENV["SHARP_FORCE_GLOBAL_LIBVIPS"] = "1"

    system "npm", "install", *std_npm_args, *resources.map(&:cached_download)
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/pake-cli/node_modules"
    rm_r(libexec.glob("#{node_modules}/icon-gen/node_modules/@img/sharp-*"))

    libexec.glob("#{node_modules}/.pnpm/fsevents@*/node_modules/fsevents/fsevents.node").each do |f|
      deuniversalize_machos f
    end
  end

  test do
    require "expect"
    assert_match version.to_s, shell_output("#{bin}/pake --version")

    (testpath/"index.html").write <<~HTML
      <h1>Hello, World!</h1>
    HTML

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
