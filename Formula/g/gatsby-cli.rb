require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-5.13.3.tgz"
  sha256 "22419fe3354ce4a4e373aaa54160294b8d5cc5ab95ad6b632b07a047c6287378"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "93e8f4c67f5e0ab8914bbc762a37c6f21dc6795b1962273d1c2954778e61fcb7"
    sha256                               arm64_ventura:  "4af3f7d83f71ba6be1011f33c0d401cec382f5e4f6ef47cdd6da230f849c2238"
    sha256                               arm64_monterey: "7de68bc0f132452013a46b0f1c3bcedeff429d80e6cd4784a4d1996b8a34da71"
    sha256                               sonoma:         "30507a2a4f791c8de4282012cb752822a46e7fe98f27db441c86d3cda10c2a39"
    sha256                               ventura:        "b4b496ab46b78d0980a5b5555b4cbd4dc41c10ef7dae267dee8d4cc82ca2a727"
    sha256                               monterey:       "71bab880233972938f092c4420aa4abdbbbc88c48504fb403df161fc3a1e40d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a83fd61a35c2e589e0f4f07d8f3ac1caa00076c4304b1bc193e687c2b49662b"
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
