class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.11.2.tgz"
  sha256 "077afecc8b7a3326fcfc7e8218948277d3f2bb50532ae0962106b56c7fc88f75"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c6e397b513ed070850e7fee8264e42afa1b6e20ddc6c335aee50d05702a8aab4"
    sha256 cellar: :any,                 arm64_sequoia: "3c85d5b449f619bd330726e7e0371a14772fee2ad9c44edf480235010bf2b872"
    sha256 cellar: :any,                 arm64_sonoma:  "3c85d5b449f619bd330726e7e0371a14772fee2ad9c44edf480235010bf2b872"
    sha256 cellar: :any,                 sonoma:        "ede35d2bfa0864de3a336c628281bb4eac999d70d7c5b60b1f9e9c2e67ba22c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cfa0a20b60fed3e3d60bc308fce3608c37cb2517c6113078805e58a9bada86f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e858612713fa2e39317332f741a397121de413335bd0ed2c62216967e2979238"
  end

  depends_on "node"
  depends_on "pnpm"
  depends_on "rust"
  depends_on "vips"

  # Resources needed to build sharp from source to avoid bundled vips
  # https://sharp.pixelplumbing.com/install/#building-from-source
  resource "node-addon-api" do
    url "https://registry.npmjs.org/node-addon-api/-/node-addon-api-8.6.0.tgz"
    sha256 "e3029e9581015874cc794771ec9b970be83b12c456ded15cfba9371bddc42569"
  end

  resource "node-gyp" do
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-12.2.0.tgz"
    sha256 "8689bbeb45a3219dfeb5b05a08d000d3b2492e12db02d46c81af0bee5c085fec"
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
