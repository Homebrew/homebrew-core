require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-17.19.2.tgz"
  sha256 "676b85473267547b6dcb80a2b4a0d25972fb940353bab778b637804221227cff"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "1dfa4ed63cadfdf644c05c2e8ebbcadc3277bc60c53d26d346e19141a52d76ac"
    sha256                               arm64_ventura:  "2408fcf888b558c25fbe837efbc4496fa0fb7d2a9260feded357239950d649e8"
    sha256                               arm64_monterey: "6696fdf3bb1addb5429550d9b0b3348e932aa682ef7e88f073301adc1eb254ec"
    sha256                               sonoma:         "a728e8d7396f0983b0c4fa524964dddfa44d697b2760e17f84e9403ee0f1f8b7"
    sha256                               ventura:        "4d34e383f7988bb4f7fdb0b68d3c38521fd11d48e501e68e8205e7cef212396b"
    sha256                               monterey:       "5b3d87409f7b2319a299d089678720bf85318598b68f9c0468848cd5ea54bd2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2ed5429d95f87c41045091f3243699bb89689992a005ad3d09f0b584cec35fd"
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
