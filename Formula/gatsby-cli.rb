require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  # gatsby-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-5.5.0.tgz"
  sha256 "5e99bf712a1081e8d2052b46bd6ed9e0251c90b894cad446311235d7923c3eea"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "702c903698aa97ca7b7a4be8429ddd696fa5b33eef1836fae74569a65dd7a793"
    sha256                               arm64_monterey: "09c1c1a26d39cc757a5f28ead17ce3629b1937b61677385789912735c2b0eba3"
    sha256                               arm64_big_sur:  "1983073f0a500e30508b2dd21ff7ffbc20ef63036c27576ee4e010a7c8e11e8f"
    sha256                               ventura:        "c91e5ff9764b8f7a072fc64c90a2569e4a4754a042de18c0f3479434bb230c7f"
    sha256                               monterey:       "4a0450b3bab1df2ba31afeb4976cb0ef4ec9c986798f9158348f2d3c291b7cac"
    sha256                               big_sur:        "af7048d65267c5b1f0297f72f188eb5122d1f0c401df50002695a96097a9e96d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da88ed88152544fd055e2f0d983df9ce0e9d66a1bd95a9c67e2ff8e94d56a5ec"
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
