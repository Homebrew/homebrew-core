class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.7.6.tgz"
  sha256 "3f5d2712b7cf63bc6cc576e731c5cb37136ed74abb56bee2fe4cb327993a98d4"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ddeaa2ccc2377d8e321811170e064b9d9df0ace28153588f3ae313c212a1b058"
    sha256 cellar: :any,                 arm64_sequoia: "ce56fda6ea7a06a190b80438f81fb30ab5a7cd45424f87de1ebbb38a1cfabb19"
    sha256 cellar: :any,                 arm64_sonoma:  "ce56fda6ea7a06a190b80438f81fb30ab5a7cd45424f87de1ebbb38a1cfabb19"
    sha256 cellar: :any,                 sonoma:        "6d6d070a6b3fdc1ba030c62be57b6db088db1e41fd542b7e4065f821b48cdfde"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c744be7b3261eb7a727e456a4025a0485e586fe301c02d4ee8fc102081da4d78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfaa1aae34c48a1355d63bed7b4aec5d70341d30ec314a6332e396f5ccdd5197"
  end

  depends_on "rust" => :build
  depends_on "node"
  depends_on "pnpm"
  depends_on "vips"

  # Resources needed to build sharp from source to avoid bundled vips
  # https://sharp.pixelplumbing.com/install/#building-from-source
  resource "node-addon-api" do
    url "https://registry.npmjs.org/node-addon-api/-/node-addon-api-8.5.0.tgz"
    sha256 "d12f07c8162283b6213551855f1da8dac162331374629830b5e640f130f07910"
  end

  resource "node-gyp" do
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-12.0.0.tgz"
    sha256 "bbe606e43a53869933de6129c5158e9b67e43952bc769986bcd877070e85fd1c"
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
