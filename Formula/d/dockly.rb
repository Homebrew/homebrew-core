class Dockly < Formula
  desc "Immersive terminal interface for managing docker containers and services"
  homepage "https://lirantal.github.io/dockly/"
  url "https://registry.npmjs.org/dockly/-/dockly-3.24.4.tgz"
  sha256 "4a8cb8eb5ff23d1e8014e8c3b02828b4c081ac4147eb5f09624737819cb1d8ff"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "700c2708ca1ed3a875a9698aaed11466d5d91a7529d97199089aace79d7a21f2"
    sha256                               arm64_sonoma:  "51229b71ba7c9b2e87ab38fc5fdc07bbbb30c967d6642c14493616121687d701"
    sha256                               arm64_ventura: "fb791102c78862dd28bf8646716703f98abb968c5419e82056e694ed0faf57d7"
    sha256                               sonoma:        "a82b61a79a6e0205fb8989b0d2529362789a0ace991bed5cd2a623833a9f94a6"
    sha256                               ventura:       "a5ff5795dc453df58faf55b982b83eb10a198bc4f6c51135f02e8e986d13c371"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85332059cc8a9b0ffd33ce01ffdb3279bfb426a3e2cf9dd1e0745083d8494a53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7ec35972880d31439b413e3f08b97f03a24a8d1cda8aa502c47fd4cabbab06c"
  end

  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    clipboardy_fallbacks_dir = libexec/"lib/node_modules/#{name}/node_modules/clipboardy/fallbacks"
    rm_r(clipboardy_fallbacks_dir) # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end
  end

  test do
    expected = if OS.mac?
      "Error: connect ENOENT"
    else
      "Error: connect EACCES"
    end
    assert_match expected, shell_output("#{bin}/dockly 2>&1", 255)
    assert_match version.to_s, shell_output("#{bin}/dockly --version")
  end
end
