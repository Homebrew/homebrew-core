require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-17.23.1.tgz"
  sha256 "8c6eb90b546ef36a4589ae2f554fa1604eb7980bb18253200baabd32704751de"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "5dc08c0f7bfeb8b0f9960e697e50914e235dd8429ee505e384baef9006cf9f8b"
    sha256                               arm64_ventura:  "9bfb9ad7cb253bffbd47bb212959c61264d3c2e4afa072cd9f51cbaf6815ce57"
    sha256                               arm64_monterey: "64fda42b5e113826fbd39865ecded57cd2c7235929a04e17454403425430b9a8"
    sha256                               sonoma:         "779e7707ea2eb5d9d5e2f315a99ea91450f01c0cee9ffb36a1add4f190169fe7"
    sha256                               ventura:        "dedd2dd183d6aa1f3f3668ce78b4bec624794b8dc4c1d85ff62b32f3fea92fc6"
    sha256                               monterey:       "4778cf67dd8b725b1b2e9fb6272a00f96c62bffd3d0df22c848e838d36836102"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5516cef6c0d8fff44a2ad67505c353c158fbde1f869040b646ee7155162198e"
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
