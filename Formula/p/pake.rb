class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.7.8.tgz"
  sha256 "9206b595e5190df77aa10da6ff0a6f454ee1b6e84774163bfb62e8c804b4cdba"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f5b754cabfc93f2693d68d6799a3c96abd5ce3cbe3f29ad1d3a089c3da7f417b"
    sha256 cellar: :any,                 arm64_sequoia: "51ec73c7928a49724026dd7aaf54aad43bc0259cfabb06016526eb291720032d"
    sha256 cellar: :any,                 arm64_sonoma:  "51ec73c7928a49724026dd7aaf54aad43bc0259cfabb06016526eb291720032d"
    sha256 cellar: :any,                 sonoma:        "eaf39e977aabc7fa5706a70915e77f7cf03df3c91f0c9aab9edea445ec85c828"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bccffae86f46d795e87ad0ba5642ef083bbdc87573919b7d5d142040e4e78e32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4d69e00da6102f37887413a155b42d43dc03914872054b4d247e17f9a36ca0a"
  end

  depends_on "node"
  depends_on "pnpm"
  depends_on "rust"
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
