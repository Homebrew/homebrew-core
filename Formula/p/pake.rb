class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.7.7.tgz"
  sha256 "cb09ef0bff990688aa6922d20a342a06d576b9a6bc254ddbbb53d08bd8b142b0"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "392d18699a5f154cb8d53f2a9c3921994d3f1ac52194f646dad587fc2f2b8f29"
    sha256 cellar: :any,                 arm64_sequoia: "f8d6bde1f09cfa0ad9d58e6fcfc12d738c2781582753f4451f27ef17cc5dde76"
    sha256 cellar: :any,                 arm64_sonoma:  "f8d6bde1f09cfa0ad9d58e6fcfc12d738c2781582753f4451f27ef17cc5dde76"
    sha256 cellar: :any,                 sonoma:        "88cee33cae3b17c17765be583f2fe1832953a88ee084a2d21d8fda931f6f1b27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1fe5c79494fc6828433920bc77eda1c2260248c9a38817233829f703537c7fef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb0f35126a842877045449f466ac2550e2063d9e8fa8a7472d6aade9311ded7d"
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
