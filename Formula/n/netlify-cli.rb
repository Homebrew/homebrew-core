require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-17.10.2.tgz"
  sha256 "24ba1970e58576902009eabc9cf4d1916568964f7075b3c82241d3c9deb64e01"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "1ef5f69d9dbfde07b03ea17a3a27b534456ada86d4f6bb19657b6310af9468f4"
    sha256                               arm64_ventura:  "8c39779ede2c992654c5f810d46b129aacbc692ebb52cd36198d5edebbeac2e6"
    sha256                               arm64_monterey: "c4a83b67455790cb1377b78caa376b0900baaaf00ecd284b00003598475bb9fb"
    sha256                               sonoma:         "96fd447e8b53350f41d5e7ddd8b600b8d5f8ca896bfeed84173f92af39bae26d"
    sha256                               ventura:        "bfc69f235caaf0a4443189dfdb88622e00b5ba080530b12e6d527c802877bcd2"
    sha256                               monterey:       "dc7cdb8f728336a7f2052e4830f30cda1608d43f8dfc5697819350071012e096"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f352ef5c353c476f95231504def7c98879298bcc7c43532229a6cf255853b85"
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
  end

  test do
    assert_match "Not logged in. Please log in to see site status.", shell_output("#{bin}/netlify status")
  end
end
