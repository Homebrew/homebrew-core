require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-17.21.0.tgz"
  sha256 "440477d0e405d9dee1771e6f913116c53bbc15910d94b7079743dc584a76c5aa"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "6d86c7f382997678852105d70038312a1f3e8d1b382693a4a06156a17f9aac9b"
    sha256                               arm64_ventura:  "a9fbd85dc9b1fdcf1b9b2295419943d999aa50d9e4ffeba7180194c81a3c09b6"
    sha256                               arm64_monterey: "4106f7f6720e35eb62094c424726033b01d4d1473a9f3f63599e24252010dbe5"
    sha256                               sonoma:         "de240fb0fbcf5f7a2ea4a9879026a2c970aa8d31d1f0c6084fd2015b766e7aee"
    sha256                               ventura:        "b34ede74fc7f8b80811eb219269da9e9c30432d9c7d0a4607d8168f08e377dfd"
    sha256                               monterey:       "6ed13bc5ca150985d8b854f5d63829f2727d421fc3e968c53e73560d30b50b7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0a68de063e1cde47314101bf1822ec50f27cf874ac4daa5cc36ca903c96ce04"
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
