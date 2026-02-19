class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.8.6.tgz"
  sha256 "76875bb3a5d76f852d9948709cd0b8f588566d35470dc8880ded9f5722987baf"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "645fb1df534bfef7980db3124362b52be3d6fde7cd3979db216ca86bfd84c00d"
    sha256 cellar: :any,                 arm64_sequoia: "4d96140746b6d07874fad1b40699f9cdb78cf47fe1100f60d72a352350320f43"
    sha256 cellar: :any,                 arm64_sonoma:  "4d96140746b6d07874fad1b40699f9cdb78cf47fe1100f60d72a352350320f43"
    sha256 cellar: :any,                 sonoma:        "6827ebd7fe9017b201789560f87145662472348a360627f5e2dfa97da6f21110"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31925b2b7f83f231a636abb7d15c01f313a49c9d8119738074c70d3e3c750eb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6af0582bae2371968343361994ab00b3994f03ed40813fa328d304f29ff82d3c"
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
