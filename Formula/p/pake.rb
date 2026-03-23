class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.10.1.tgz"
  sha256 "ced1c05b26a25923b41ae3c5336d498fe2753d0ed8ef0fedbf308c48a0c4e42e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "65bee35f28778d15440a74998cf6f53c4eb8fcb62ae0f970e51556986baa3aeb"
    sha256 cellar: :any,                 arm64_sequoia: "d2ecf9e671870d99e515b4de67f2df11266a5e0bc5c100f8dd121219104cb4f4"
    sha256 cellar: :any,                 arm64_sonoma:  "d2ecf9e671870d99e515b4de67f2df11266a5e0bc5c100f8dd121219104cb4f4"
    sha256 cellar: :any,                 sonoma:        "8a72993fef63b6a9ff57b025d58166716331223b9c08d9c23c41f37660bf1f60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1312f725342b8b0194c77a5b75a577aae0a4c084a0680e894a4a9acab4d807df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b83ae476260922dfbf525fdea13c6356219d1fb8110e648d97f29f54dafaddd"
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
