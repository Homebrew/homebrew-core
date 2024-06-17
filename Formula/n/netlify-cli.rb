require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-17.27.0.tgz"
  sha256 "f58624d39c77bc0db14402002ff25582c7677fcecb7584cad9211f01eda41418"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "686c45c317ae3ca52d4e7e9c24cf4e5f37e51656605eeefb827ee58e8d7f9f2a"
    sha256                               arm64_ventura:  "d629f999e5fb2645256d0affb9a5e8988066742fa1bc05da0b9e3b240e196c60"
    sha256                               arm64_monterey: "ae20110aba9625d103868599191f3986be996856071987b3126e06de6427d9eb"
    sha256                               sonoma:         "2592e54fc68d42bc3bc4e1d384029dfb80dbf629e3847ee66e0e24e5a1c4e4d6"
    sha256                               ventura:        "4d2773d0f08e2c1329e88f9be064314fd3c10f2c41ac7791ce6abd2163c0a24e"
    sha256                               monterey:       "88f43a9d9fe1f06e4398ef84188b59bd17097ce53d7f6f813cf5911ac8ca56ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db853dd5d1335184a497a2bd930e29eaca1efb4b81daad2c98613744dc38687a"
  end

  depends_on "node"

  on_linux do
    depends_on "glib"
    depends_on "gmp"
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
