class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.27.29.tgz"
  sha256 "d504d02732c61240103add9eb4bdb0ac8fb3d6f5b178e8eeea79677bc8ac9c8c"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "acd2eed60dbd8dc20a5c515f3609dee8869fc63602094044539b21fcd5c01c0c"
    sha256               arm64_sequoia: "a36a625c1ade27bc433b86dde35a54a21fb48d3310b7fc4eef01dce347277ec9"
    sha256               arm64_sonoma:  "3cbd685db537811f2d6315faf1c8c1e31d5cc7c409b738b1264a2d3ea6e05434"
    sha256               sonoma:        "88dded1af7772aa48e776816e9a090f769f8ea82807d5663b15ca06064912902"
    sha256 cellar: :any, arm64_linux:   "89b1ebbe6fdf3a70129fe8d57961b23cac882ad643efefe0ca7bec2941c789b6"
    sha256 cellar: :any, x86_64_linux:  "4ab20547638638801a3cea3bd0360fc93ab70af01c0b5082ca98c0b8bdfc5a85"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "node"
  depends_on "ripgrep"
  depends_on "vips"

  on_macos do
    depends_on "gettext"
  end

  resource "node-gyp" do
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-13.0.1.tgz"
    sha256 "455327cde805c299d5a16603419e106853db5b9257dfb85e44eb7f4ec4d99de5"

    livecheck do
      url :url
    end
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove ripgrep pre-built binaries
    node_modules = libexec/"lib/node_modules/@letta-ai/letta-code/node_modules"
    rm_r(node_modules.glob("@vscode/ripgrep-*"))
    rm_r(node_modules/"@vscode/ripgrep") # keeping separate from previous rm_r to fail if missing

    # Replace node-pty pre-built binaries
    cd node_modules/"node-pty" do
      rm_r(["prebuilds", "third_party"])
      system "npm", "run", "install"
    end

    # Replace sharp pre-built binaries
    rm_r(node_modules.glob("@img/sharp-*"))
    resource("node-gyp").stage do
      system "npm", "install", *std_npm_args(prefix: buildpath/"node-gyp")
      ENV.append_path "NODE_PATH", buildpath/"node-gyp/lib/node_modules"
    end
    cd node_modules/"sharp" do
      ENV["SHARP_FORCE_GLOBAL_LIBVIPS"] = "1"
      system "npm", "run", "build"
      rm_r("src/build/Release/obj.target")

      # help letta.js find source-built sharp
      sharp = Pathname.pwd.glob("src/build/Release/sharp-*.node").first
      (node_modules/"@img"/sharp.basename(".node")).install_symlink sharp => "sharp.node"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/letta --version")

    output = shell_output("#{bin}/letta --info")
    assert_match "Pinned agents: (none)", output
  end
end
