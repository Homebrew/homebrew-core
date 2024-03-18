require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-17.19.5.tgz"
  sha256 "8e20aac63422a3ea05bcb01f2e2737441b401d437af170b4592ab3242af3b0e2"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "5a7a4c619045952b2d80db6692edccc4ab8bc69fd67b42ccfafab424f906a2c7"
    sha256                               arm64_ventura:  "1b3470068d2894826e744eeeb9b446dc32eee7b704b7e75956c1ad0dbc6ec1f8"
    sha256                               arm64_monterey: "8af191309a4b73a837137e38ca9c476cb023b4105d4048f780adba7217099512"
    sha256                               sonoma:         "3a21e788fea321856088cae816eff5adec50157aa6e745e427b31f35b0223fb8"
    sha256                               ventura:        "b8d64fdf66b1c79fc0b78d2636af0e51891fb692c72c4a233a9b12ad4b971f73"
    sha256                               monterey:       "f7f8198c48402d1b213fbe796892f1c8412cfb49a4c0a1c759684d233a921b3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b59eb713dcec2f383c0f6298625941291c7c98c23ed2b4472941249d41e73de"
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
