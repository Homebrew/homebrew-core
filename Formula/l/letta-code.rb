class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.34.70.tgz"
  sha256 "a617768efb5a739bb9675b94ae101593f25e41c70b392b2ecaa2241478bf01a2"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "80f9c7c66b79ae5d1957f5cf9de08d8307534a4c555c93b11e6d78c8dcdf1678"
    sha256               arm64_golden_gate: "29d6d059fcb014a3ba29aec9914be93228167c25983317367a77c32c600db9c4"
    sha256               arm64_tahoe:       "ceaa1f7231ff63f5b660b35c1d871d31929eeb3caf1160e6447c9776324f048e"
    sha256               arm64_sequoia:     "22d6c843d089f7a2230f69c66d7c32120b9e9bbd6f4fac9d115196c66e60b70e"
    sha256 cellar: :any, arm64_linux:       "365e19490e9e3f9f2b0f9a440ad87f79e46bc7ae7ccd8a3c5a42dccf29c9751b"
    sha256 cellar: :any, x86_64_linux:      "ed11c6c9eb330a271e168b14d57e0f4de2c7b07d6b3e44ba753c5cb327fd710d"
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
