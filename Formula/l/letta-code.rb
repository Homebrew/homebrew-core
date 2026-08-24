class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.30.29.tgz"
  sha256 "b6c629def4c90b7f8cdff23d1c271eb364c99cbf6e247194d00dafa346e393ac"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "4946b6b27213f495f7670507600bc2fbab2d815843b6e83bc4dbfd0662ffb367"
    sha256               arm64_sequoia: "36e011dd9025c8cdf43351b36299a46281ecdabe16613b271b6679f06371f010"
    sha256               arm64_sonoma:  "da6773927443c57f6b58ed67dd38070e68efc671a5e07c7c70ce369bcbb8897d"
    sha256               sonoma:        "f4c360bec974eedf1efe69dee505e7ed148fcaf97730997d0c88d4720ebb1693"
    sha256 cellar: :any, arm64_linux:   "44a1467764883cf84c32b2060aabadcdd23fcf198c56917eac84ad0237bf5881"
    sha256 cellar: :any, x86_64_linux:  "368a136622e3cbb6c1e37d4719ded195c873428967c0b212c18f928dcd18bb19"
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

    # Remove Electron-only sharp fork with x86_64-only pre-built binaries
    rm_r(node_modules/"@janhapke")

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
