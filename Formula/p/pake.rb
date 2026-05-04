class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.11.4.tgz"
  sha256 "4d43c82e337a889692f47816ce9fea85d08d3bc792d734e28d0dba819abc8371"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "047b2a7ad3397975111f84330946d692d2fefc392a7fd0e974517f1a7c815131"
    sha256 cellar: :any,                 arm64_sequoia: "b9f15f1631d652720456009831cb7375fc19bbf22391857236b2c8cdf92effa0"
    sha256 cellar: :any,                 arm64_sonoma:  "b9f15f1631d652720456009831cb7375fc19bbf22391857236b2c8cdf92effa0"
    sha256 cellar: :any,                 sonoma:        "78399aa9766efd7da7e841bd09b5da4166a132051433d399a53cbcc394794a75"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46aae1f82436b37d5a926b77bba58993349c47f392d0f42eb8b1b2a993c50779"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ebf1474e564c9a05b06154da5f5b893b094be91417b39adcba7baa7cb23e234"
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
