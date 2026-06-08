class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.11.7.tgz"
  sha256 "93bdd93ebe316233690dc9eaabe9871db33336f52b26f07e5a487e624cb5c620"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7b341fdf8bf02f5da14b0b9a2170b169c158125c0bdaf5b4213583c40cdfbd4a"
    sha256 cellar: :any,                 arm64_sequoia: "2e30e09a5305f22d4b832e7459575c1bbcec7a0001a17fd1bde3df81a55aec79"
    sha256 cellar: :any,                 arm64_sonoma:  "2e30e09a5305f22d4b832e7459575c1bbcec7a0001a17fd1bde3df81a55aec79"
    sha256 cellar: :any,                 sonoma:        "a5af57cb3f73d405ee4e117b588b03dcc422674bfd167e0523fd3ebc80a876ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e3f05a0abc801fad3a65476b8b2790b4428e5d3de9ee8a3f3b079cd2b7b28f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "999f5637d1891937ce302af9adc9a9af75f30d9d4a0f1ec3dca60eab50ec0126"
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
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-12.3.0.tgz"
    sha256 "d209963f2b21fd5f6fad1f6341897a98fc8fd53025da36b319b92ebd497f6379"
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
