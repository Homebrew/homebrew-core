class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.30.27.tgz"
  sha256 "3f38a51f8673f781386c3be56b5bfd8fc4ccb3e8ee002969040c6a3c795ead38"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "c7d200abb5e71821b0328794dbbbbaac690a342861460ac5f7d23684db298c26"
    sha256               arm64_sequoia: "d97433b2912b5d0b849d6a224128ef17aa02b5ee56a35d4ba9bf5e8632e46dec"
    sha256               arm64_sonoma:  "b523218d044d56912162ffad1a2b6f6476c3b7eda1d4b4006591a67430999242"
    sha256               sonoma:        "79a704d5b2ff124872be7190e910a285892981f9ba5f6b7dfed0da40205162d6"
    sha256 cellar: :any, arm64_linux:   "95cf6e42455428d7633bee29cdc13788713bc22c5e7db0fd5a03f2111b071899"
    sha256 cellar: :any, x86_64_linux:  "a2e6a490d6b22af37b4999821fd1195dc29c1a6f6d190e06b7d2b97120f8d0c8"
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
