require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-17.16.2.tgz"
  sha256 "434d94d456ca654cb3036e3a89c893b97dec044556431f6fe940dea1a907bc41"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "97494846b33cfe0aeb6a317603a2c7c10c999a1047b5e615fbc5d593fea775c3"
    sha256                               arm64_ventura:  "b641c3eca3f863b518782aed0bfe2be7861e99e141461f81ec0b99a7791d20b2"
    sha256                               arm64_monterey: "c223fb99807fcc0726497cbb25f60f5be341cad1cc4ee16da890d158734bfe3c"
    sha256                               sonoma:         "20fb508abfac459d52ba025fb359982fff1061f2fe52d9bfe9f8ea4b8b458235"
    sha256                               ventura:        "78170fb9b978f6f3227eb1bfe9390af704e34bcb7b963b63cb8ac008a386abfa"
    sha256                               monterey:       "caa8f53acdd3950a9509c5526521b3535b3d792f0baa4f43d7dbb491ab6f2457"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12f4d42b01e8b490b4230a4dfe1705dc27c71f0ec0117a58eb8e49ae2e117a54"
  end

  depends_on "node"

  on_linux do
    depends_on "vips"
    depends_on "xsel"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    node_modules = libexec/"lib/node_modules/netlify-cli/node_modules"

    if OS.linux?
      (node_modules/"@lmdb/lmdb-linux-x64").glob("*.musl.node").map(&:unlink)
      (node_modules/"@msgpackr-extract/msgpackr-extract-linux-x64").glob("*.musl.node").map(&:unlink)
      (node_modules/"@parcel/watcher-linux-x64-musl/watcher.node").unlink
    end

    clipboardy_fallbacks_dir = node_modules/"clipboardy/fallbacks"
    clipboardy_fallbacks_dir.rmtree # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end

    # Remove incompatible pre-built `bare-fs`/`bare-os` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os}/prebuilds/*")
                .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match "Not logged in. Please log in to see site status.", shell_output("#{bin}/netlify status")
  end
end
