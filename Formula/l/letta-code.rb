class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.28.15.tgz"
  sha256 "ede0163b91eb428433d5458593a261d1c3ba3102dc9b0703d72e4ec89d505dff"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "a3ebba34690955cfe5b530c2e22a398730d4b8458665da4e37410f03a13c1934"
    sha256               arm64_sequoia: "a71e045cd9bbc347cbb0fb66628f0802be1190b353057f2ada2ce29c57f632d8"
    sha256               arm64_sonoma:  "75a74fa066a718c13c57678a2df7382778fdab97b9db2a268d81308109c31af1"
    sha256               sonoma:        "9af55240d48b97817c513e8a782c1f8fa54be6675825aef3e2a3b79d8dfa06c6"
    sha256 cellar: :any, arm64_linux:   "c52fb99e86ab5770f425070c179fe5d7a5db4fb3654322a12ee7c72eee1b253a"
    sha256 cellar: :any, x86_64_linux:  "f90b0f0f49bd6e09e0d305da53041294941c2e91ee1dd3b4cb200a5afa0aa993"
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
