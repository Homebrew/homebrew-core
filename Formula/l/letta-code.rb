class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.27.26.tgz"
  sha256 "420f0dad82b1cdb33f7f8da09ef49543ec31cb3f9c4f64907dfbafb7d1184583"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "54c8365cf1d593a449c098218408235f64f1f2174ea1907596343ad934bafb25"
    sha256               arm64_sequoia: "f389d5a1dda1e9e3cee4bdd667e62efb3932fa096ac099174e9e11b76c72718f"
    sha256               arm64_sonoma:  "a3f3fcf217a7fbf9426ff2762421a184e9d3649a7a8cb11ec7c49459909ce94c"
    sha256               sonoma:        "8ae50b682d59dbe29f4d3cc559b4c2dad7e95cd1b9a1f2573987bd78a304978d"
    sha256 cellar: :any, arm64_linux:   "5e891880f7cd7e8f45bfff908775ee4f3c894ad3c8c375d3b617435afddd5b27"
    sha256 cellar: :any, x86_64_linux:  "dbb60ab2a2a10112ab6eaa2f026b9f8ffff79cd3a675eade2024c5c917031b51"
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
