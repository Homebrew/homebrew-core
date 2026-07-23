class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.15.3.tgz"
  sha256 "0dde759dbe02cd17bcb5d1a6ca911504d10ddf644dfc7b2667e158d683d5d09e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9a762c1001b7643ca2d49266c433862ed17b3661e987fa78b8f05d2bacce4e9d"
    sha256 cellar: :any, arm64_sequoia: "9a762c1001b7643ca2d49266c433862ed17b3661e987fa78b8f05d2bacce4e9d"
    sha256 cellar: :any, arm64_sonoma:  "9a762c1001b7643ca2d49266c433862ed17b3661e987fa78b8f05d2bacce4e9d"
    sha256 cellar: :any, sonoma:        "0601518ea1c9303bcca53ce742f0cf8858d619deed58c84de9efb4c191a17364"
    sha256 cellar: :any, arm64_linux:   "38ab827de062607fe36f43ff88dbdbe05178a0c84c62389a11ab389c9cc551d1"
    sha256 cellar: :any, x86_64_linux:  "fc2c6c212c1e566173d1029e9c005b3c17d1cb821452bdc47a5f5d2aa389ee4a"
  end

  depends_on "node"
  depends_on "pnpm"
  depends_on "rust"
  depends_on "vips"

  # Resources needed to build sharp from source to avoid bundled vips
  # https://sharp.pixelplumbing.com/install/#building-from-source
  resource "node-addon-api" do
    url "https://registry.npmjs.org/node-addon-api/-/node-addon-api-8.9.0.tgz"
    sha256 "19b87e2ce3a77fec0121ac97d7db088aae28aacfff481adab50d5f61b70e68f4"
  end

  resource "node-gyp" do
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-13.0.1.tgz"
    sha256 "455327cde805c299d5a16603419e106853db5b9257dfb85e44eb7f4ec4d99de5"
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
