require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  # gatsby-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-5.3.0.tgz"
  sha256 "7b249df477e09e975d91d846ac8dbe13795c057956d04a10cceedc7b8fe4e744"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "0ade3e822f2cb53ad09cf44a7a517b720505ae1b5af0e0cc9300acf9a80b2796"
    sha256                               arm64_monterey: "00635bc47eb8d6706a361a1c24e4e2df50c28b658b381a50e5ee519ee7fbc17b"
    sha256                               arm64_big_sur:  "fd15f263c27b67da59700a3d7030dc1da0eb7e19e3f184c751921d95fe7971d0"
    sha256                               ventura:        "ee62203998060482dc0f47b36cf2cba42424d351762e91d10e191f1f72326efe"
    sha256                               monterey:       "b5fbacfb1c2e2c5fe84cc98c0e2143f11c29c16c8db18e73127f30b7ee7f3ed1"
    sha256                               big_sur:        "72726715f2ed90b391d71b71a48c277b96a81373f62a90a6a36eaa45b80ccf63"
    sha256                               catalina:       "015b0c4f353d05eadf78567c2001392868983830280c893447c3a370163f346f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2e603370adb27cc9aa5391a47ee57c1161644bd4911432843bfc7cb7d1cdd8d"
  end

  depends_on "node"

  on_macos do
    depends_on "macos-term-size"
  end

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

    term_size_vendor_dir = node_modules/"term-size/vendor"
    term_size_vendor_dir.rmtree # remove pre-built binaries
    if OS.mac?
      macos_dir = term_size_vendor_dir/"macos"
      macos_dir.mkpath
      # Replace the vendored pre-built term-size with one we build ourselves
      ln_sf (Formula["macos-term-size"].opt_bin/"term-size").relative_path_from(macos_dir), macos_dir
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
