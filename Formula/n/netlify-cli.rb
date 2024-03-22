require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-17.20.1.tgz"
  sha256 "f6251cd34b48fd1fd9d4b9d49b81b2abc9babc1dce5166dd4bbd64dbb88d439f"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "83152d0f332a83718b4753ce0b4b66a2f72d9f6765282af945b05b2662acaaf3"
    sha256                               arm64_ventura:  "c9eebc6d1be9c454007fa11c8c0768a583430b91f5a339b668f35c147eb92d05"
    sha256                               arm64_monterey: "316fe25020033590d7d1790ab1464fd8c63ff289dffcbbb375664185b03e07bc"
    sha256                               sonoma:         "01db50f6e93cb3b45402ddcfaa90bdb65fe9cc4dccaa940631bcfea75195e099"
    sha256                               ventura:        "4fd5704118caba8c953fc3627f90e88a63b2c949c0efcc3c20973ba38d0d765a"
    sha256                               monterey:       "98d650ecec574f087977e2f3ecab3a0be98021714334c854a5f1d03cdb8fb965"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5acd1f019c6dcefe4a17bf34c3ba51fae73bb093b5bf9a675ab57045cff3216"
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
