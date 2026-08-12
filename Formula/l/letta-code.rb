class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.30.18.tgz"
  sha256 "468ddd604efc63d7ac2454509796f8d3aa8f7b8c8b42fa685ed8bb141801ac4f"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "23f87e27e019481c527956e457f659cf8c1b7300c2dee00652a1b6fe10a63da5"
    sha256               arm64_sequoia: "7fa6c0177776f33505938fef48d51605c2c23547297ae1204b4d33b618b62243"
    sha256               arm64_sonoma:  "2bf6bd18e1d8976ec28b36c40d68211c97d7690714a9ec00d396ed5d826f5ce8"
    sha256               sonoma:        "ce346cc663ce23436e0740c1e0c7ef731d9253739afb69e7f3fb6d5b4b65aca1"
    sha256 cellar: :any, arm64_linux:   "e228d51cdc09670414275ca3282828ac4fe5c12b1dbe1285eda794c3689deb7b"
    sha256 cellar: :any, x86_64_linux:  "8f41795b783739da06029a31d997a3d0386d4f5ddb6f4ea66259d1205a4aa74e"
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
