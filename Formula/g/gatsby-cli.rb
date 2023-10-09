require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-5.12.2.tgz"
  sha256 "2e3e1d724f6fd89fd370a4b9e3ffcc6f291bef13ac3cfae9900664e2128b1524"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "8b81f5bb57fd161552fd31da9cc73b6fa92bf48686dc34aaa198ef7377c9ec17"
    sha256                               arm64_ventura:  "15c4570b78a71854415315182cd892bce79273f2eaf50f7b9542d2fc8523b134"
    sha256                               arm64_monterey: "34e376c185eabe363d63db5e94febc92ca66769ec84464b804118ef320dcf48d"
    sha256                               sonoma:         "cc24a31d914f48d9bf560dc7c1da0003f5ad86685e59f17803163d2cf96dbf96"
    sha256                               ventura:        "aca38e42585ffcd89ef9caa101b1a0c4e0ac413ad72ea406d587fa415986642f"
    sha256                               monterey:       "a9e7ad92fc2097f7663c7578185ae2bc3100c3a7d7fbc6866862f2078d9e7e8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3de797c1414503ce2b506ecfaf7f0be1995709bfa529d00ab782724ce8e180f8"
  end

  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]

    # Remove incompatible pre-built binaries
    node_modules = libexec/"lib/node_modules/#{name}/node_modules"
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    if OS.linux?
      %w[@lmdb/lmdb @msgpackr-extract/msgpackr-extract].each do |mod|
        node_modules.glob("#{mod}-linux-#{arch}/*.musl.node")
                    .map(&:unlink)
                    .empty? && raise("Unable to find #{mod} musl library to delete.")
      end
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
    system bin/"gatsby", "new", "hello-world", "https://github.com/gatsbyjs/gatsby-starter-hello-world"
    assert_predicate testpath/"hello-world/package.json", :exist?, "package.json was not cloned"
  end
end
