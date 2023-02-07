require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  # gatsby-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-5.6.0.tgz"
  sha256 "aed9f63721dc33ab7bbb15a25f0407ed11c4063a454b05e7b2e306d4d47424b6"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "7d1eb3188b6da0e04086c7df9d3501c3a2423267448dc76cb67652de325f3a0e"
    sha256                               arm64_monterey: "71e3dcca9273e6a32f5397c3e1c46d4897800265f58a9a166bc28843e8910123"
    sha256                               arm64_big_sur:  "c67fa9911043b98b9eaf7acd48da645e7ec8e463c728c5a1f5b3cd7a53df3c4b"
    sha256                               ventura:        "dbc3e618427de511211f40bbe95fa1d84fcabb6e69a5abd03baddaedad0645c5"
    sha256                               monterey:       "d564761361153dda97902cf6144b96e0dfeac79a20fb60b3f8c66c78ce46e7f0"
    sha256                               big_sur:        "b477cac838e60105d724b821011712f409f203c71f21113e706532d9597d5aa0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "542474f9582fd89701e4cfff6baaa9afd4aef656a004745367af4ad37955a74d"
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
