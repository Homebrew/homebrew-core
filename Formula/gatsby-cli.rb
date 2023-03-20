require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  # gatsby-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-5.7.0.tgz"
  sha256 "9250b020c004af542c1f64a5af845f77f899fba5a6a51ce2bb6f5cc90078e0c4"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "e1377580f96a1b98d54563acbf90af730f1cb2027d6d3e2f272171b40c169922"
    sha256                               arm64_monterey: "06b0eb7132a1342b4611ccfb6419efefb90b3a44adf222b154f907beacc79e32"
    sha256                               arm64_big_sur:  "e1fe50cb90f84031ff23d33fd5fe34b85330e2b649c77c1738c5d215f6f985f1"
    sha256                               ventura:        "efcacb04bf31eade018d5157f3127ff31376f367436ada578bb9187571c24757"
    sha256                               monterey:       "defbc94b94682706072acf0fe1a3099c7517e0afd439749d5d13fa01762b443a"
    sha256                               big_sur:        "ab8bdd76a6f2a79d81b6f3b8f37ab4f65984f9906509465a56a50b877a5b857b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1416730204ff61c51cd3e2c31dc91863cb6db0995754b71b7422b7d93e0a67f2"
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
