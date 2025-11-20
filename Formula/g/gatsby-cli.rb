class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.com/docs/reference/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-5.15.0.tgz"
  sha256 "c0da7d8dc8c58801afc1e2b762f929114476ef0bafe087e0d785448d55505209"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "b919c17d7ef90bad899e0f5edac1e66a8e43188387c0aa431a3b8bef71c33a6c"
    sha256                               arm64_sequoia: "60c32c25f7895358b0b2debd6101c7d8398836cf7a8c94e0a31f38c60e82f78a"
    sha256                               arm64_sonoma:  "ae8617098d7c76f819ea7b9622498499948d7ed50485b70afa27e9e75a153f90"
    sha256                               arm64_ventura: "d8249abdf0fa71a4aff5bd81b35c07e15ec472e412398c3ac5dd6412687003f4"
    sha256                               sonoma:        "4f4f4f367edfbf6c36601931e8a7e2f55e7a4bc84399806788ff2f0a97d26f2d"
    sha256                               ventura:       "6935e6c506d55ceebe9fbf1394002bc876fe8dcd71eff263bc7deccf3b955864"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad7eaaecb438fe059642fa74f84d9ea3784d437acc091ab9ee94f7d4219bcd28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aad21bdf988aa03d28ab847d627f4c63025fad8c86ecadd1bd822b772fcc3f24"
  end

  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
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
    rm_r(clipboardy_fallbacks_dir) # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end
  end

  test do
    # Workaround for https://github.com/nodejs/node-addon-api/issues/1007
    ENV.append "CXXFLAGS", "-std=c++17" if OS.linux?

    system bin/"gatsby", "new", "hello-world", "https://github.com/gatsbyjs/gatsby-starter-hello-world"
    assert_path_exists testpath/"hello-world/package.json", "package.json was not cloned"
  end
end
