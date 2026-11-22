class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.34.68.tgz"
  sha256 "c257511bd89e5926590ba51691fdae4e108eda7b0ab1f8f542fd006b2499f3b6"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "16e4b4691e1091a65e891173d12e63f5e5b5889b3b99a48c87ebeb194970bf1f"
    sha256               arm64_golden_gate: "06ee2c8d37f60a742f9830b0e5ae4ca743eced672f178b973469d3309bc9a326"
    sha256               arm64_tahoe:       "6077752bccbe08b6f6b4912976273443c1d8fff48fee7bae1280b35870195f68"
    sha256               arm64_sequoia:     "80b063f75593666b82220bb380ee8ff2e5818ecff583982c2d586d2ed767467f"
    sha256 cellar: :any, arm64_linux:       "3d25cc326b3a91d19930729f3f21fdfd2a01467081b8d7d21a4d87f8930b5d89"
    sha256 cellar: :any, x86_64_linux:      "96ad553da99009afef64a1258d3ac45d3ae4f6f0070f4bf6ed3dd3dd7c6cc0ca"
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
