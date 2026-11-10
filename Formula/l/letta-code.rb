class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.34.48.tgz"
  sha256 "a61e68a4fa478d64492a22c3a0eea115acfaf243d3fb70c48a3a93076c231dde"
  license "Apache-2.0"

  bottle do
    sha256               arm64_golden_gate: "acacaa8dfc9ece00f1d33cb116b493afa0dd95b99a26e97ff10b69d9757e0904"
    sha256               arm64_tahoe:       "a11470b9b47ea0fe6c8eefc0091fa51e6bf98cfe26effa6c14c131f211651df8"
    sha256               arm64_sequoia:     "de054fcf11e1993df29d892d98a02cb0b6dd9a306084156f94784f265b56d61a"
    sha256 cellar: :any, arm64_linux:       "54e010bad64cf1d7bd1dd4fdbbad191832f4e0f88526fe902b8d6523990592d7"
    sha256 cellar: :any, x86_64_linux:      "7e38585192ab3493bf5586a83c6b5648077b0d0c29251b97d0051ca0192b21cc"
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
