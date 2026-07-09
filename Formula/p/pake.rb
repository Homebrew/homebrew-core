class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.13.1.tgz"
  sha256 "cc3e4764ba20614700e7927e5d861da89996789a6116af6c901d579ff603070a"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f48c8c59cfd7d1d54936fc67a265444de30127dbc1341da112b2907acb7d1ca6"
    sha256 cellar: :any, arm64_sequoia: "c12b87218155ac8979d5bbd7efd3d19f799a7810d519f0dbdd34e180c746afde"
    sha256 cellar: :any, arm64_sonoma:  "f1590dc1965fe3b9d0fdfd4111786ed7567b34aa7bf2638097c99383395a7343"
    sha256 cellar: :any, sonoma:        "7e31b1ef8bc23dcfe2a0848b61cc52edf83982d80d5374101d93f12d96098669"
    sha256 cellar: :any, arm64_linux:   "31fd9eab76fa3cd01d1b078ebbed7fe62a025468bef37604e709dd61f6710e99"
    sha256 cellar: :any, x86_64_linux:  "47b12098ae1fe1e773a9e10af4434d06f89096b2216b44297b63422335a6cdd7"
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
