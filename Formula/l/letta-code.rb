class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.34.52.tgz"
  sha256 "151af46cedf3d7f96cfb99933a154b9403d344631ad4732c7fd1d37f579cc6b7"
  license "Apache-2.0"

  bottle do
    sha256               arm64_golden_gate: "c20ca5974fa0aaaecdf95dc711da096e2acdf7d56203b973a3e9c67be2e09998"
    sha256               arm64_tahoe:       "a7aa28e13824bc3ee8618e82b84ab980755f148bd61aec1c9ea7f3ebb50f35aa"
    sha256               arm64_sequoia:     "8172f306db3b73415f0b4e8202a0fda9b91e9849357565d188653d3626d38392"
    sha256 cellar: :any, arm64_linux:       "21030b49c8aaa9c30da8e5a81e8a253d4de7065b71275779327046078104333d"
    sha256 cellar: :any, x86_64_linux:      "128d3dbb4f0e5936029fb6a48fc6b55e223d1eb9dda02f3a98f998ca290cbded"
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
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-13.1.0.tgz"
    sha256 "15663ca4944844139023390f057e86f1897d855959ea7e96f151d4873be8c71f"

    livecheck do
      url :url
    end
  end

  allow_network_access! :build

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Include nested copies installed by letta-agent-sdk.
    # Remove ripgrep pre-built binaries
    node_modules = libexec/"lib/node_modules/@letta-ai/letta-code/node_modules"
    rm_r(node_modules.glob("**/@vscode/ripgrep-*").sort.reverse)
    rm_r(node_modules.glob("**/@vscode/ripgrep").sort.reverse)

    # Remove Electron-only sharp fork with x86_64-only pre-built binaries
    rm_r(node_modules.glob("**/@janhapke").sort.reverse)

    # Replace node-pty pre-built binaries
    node_modules.glob("**/node-pty").each do |pty|
      cd pty do
        rm_r(["prebuilds", "third_party"])
        system "npm", "run", "install"
      end
    end

    # Replace sharp pre-built binaries
    rm_r(node_modules.glob("**/@img/sharp-*").sort.reverse)
    resource("node-gyp").stage do
      system "npm", "install", *std_npm_args(prefix: buildpath/"node-gyp")
      ENV.append_path "NODE_PATH", buildpath/"node-gyp/lib/node_modules"
    end
    node_modules.glob("**/sharp").each do |sharp_dir|
      cd sharp_dir do
        ENV["SHARP_FORCE_GLOBAL_LIBVIPS"] = "1"
        system "npm", "run", "build"
        rm_r("src/build/Release/obj.target")

        # help letta.js find source-built sharp
        sharp = Pathname.pwd.glob("src/build/Release/sharp-*.node").first
        (sharp_dir.parent/"@img"/sharp.basename(".node")).install_symlink sharp => "sharp.node"
      end
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/letta --version")

    output = shell_output("#{bin}/letta --info")
    assert_match "Pinned agents: (none)", output
  end
end
