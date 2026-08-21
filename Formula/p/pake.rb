class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.15.7.tgz"
  sha256 "3fea5e929effcddded6ef2fb6fc7bdc49c32f560697b338013733d95b42b0e7d"
  license "GPL-3.0-or-later"

  bottle do
    sha256               arm64_tahoe:   "17918a9790b3169f6928eec4d4653334d250c3173e363796cf4264544693ada7"
    sha256               arm64_sequoia: "a1e90cdf4b118870246492e1753174d0a39e621b25e20baf2c4bc66c5b12fb14"
    sha256               arm64_sonoma:  "b307229a46ba9d03c0aa1413d1ad4d99a6d0cade55f72b4d5259d1421158acdb"
    sha256               sonoma:        "c4253e57fbdcccdbc281a2f8d8d6a1186f438e4e363a823af0f914aa7fe31711"
    sha256 cellar: :any, arm64_linux:   "5e4da0913afa6859dedbf1ef4e5997197dc86369934b9891d75c1c349f83f10f"
    sha256 cellar: :any, x86_64_linux:  "8cd55d183712f5ff7e726ad51f16fa4c04bdb024c6f058105d19a20815aa703b"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "node"
  depends_on "pnpm"
  depends_on "rust"
  depends_on "vips"

  on_macos do
    depends_on "gettext"
  end

  # Resources needed to build sharp from source to avoid bundled vips
  # https://sharp.pixelplumbing.com/install/#building-from-source
  resource "node-addon-api" do
    url "https://registry.npmjs.org/node-addon-api/-/node-addon-api-8.9.1.tgz"
    sha256 "9091c2a5e57dae6ae5a0ca9c42d6127586bed4168cc1a342c95b64e61efd60af"
  end

  resource "node-gyp" do
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-13.0.1.tgz"
    sha256 "455327cde805c299d5a16603419e106853db5b9257dfb85e44eb7f4ec4d99de5"
  end

  def install
    system "npm", "install", *std_npm_args, *resources.map(&:cached_download)
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/pake-cli/node_modules"
    libexec.glob("#{node_modules}/.pnpm/fsevents@*/node_modules/fsevents/fsevents.node").each do |f|
      deuniversalize_machos f
    end

    ENV["SHARP_FORCE_GLOBAL_LIBVIPS"] = "1"

    # `sharp` ships prebuilds whose bundled `vips` shares the brewed soname
    rm_r(node_modules.glob("@img/sharp-*/lib/*.node"))
    rm_r(node_modules.glob("@img/sharp-libvips-*/lib/libvips-cpp.*"))
    cd node_modules/"sharp" do
      system "npm", "run", "build"
      rm_r("src/build/Release/obj.target")
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
