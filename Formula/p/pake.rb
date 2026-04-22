class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.11.3.tgz"
  sha256 "9af106b4a8a99ddadf72bad6356c85b6032112a57091d17f7b7f23cb4caa8bb7"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d95e44c5f5f91afbe4c7402dc30960a1150442b173fcb5a7104e6b204e345637"
    sha256 cellar: :any,                 arm64_sequoia: "e25f2accfdc1afba58d9f99c0b754ab7653156d4d09c2b9cca8382a86430811e"
    sha256 cellar: :any,                 arm64_sonoma:  "e25f2accfdc1afba58d9f99c0b754ab7653156d4d09c2b9cca8382a86430811e"
    sha256 cellar: :any,                 sonoma:        "d648a4ab62fa5a1790c05f826e89af731672a67861692f7d48242027b61d1790"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d74f62f5f49c3e4bc5f33d6c642923e99924130a5b565e5af9d4bbff2b1e696"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53dc0e7478e2e7fb968050a7df5eef9ff5d0af572f9436770747b3e4e0e82d5b"
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
