class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.32.7.tgz"
  sha256 "67f80b6bbd86bac19f8ecc6d0549ebaa2da7c3b83d46c0380a594a3d3a712a09"
  license "Apache-2.0"

  bottle do
    sha256               arm64_golden_gate: "38832fb31032c1abb399902dc30f78f3900f09f4fb6ce0b1b1de4193d5e69aca"
    sha256               arm64_tahoe:       "e7641b714a5579900ac02b7d6a11f2b12dde4b0d48aebb7195d13d812dce9380"
    sha256               arm64_sequoia:     "ff177bc01dde7c1957d9185af81e2ba461fd65ddbaa99a8251abcec3b0b0fe28"
    sha256 cellar: :any, arm64_linux:       "7174f2b7ce63dd91384a1403269ac0f381b076322086a0620545c99da2d71b2d"
    sha256 cellar: :any, x86_64_linux:      "0351555faa607ebe7b3e821ba2dbfebd63fb239eb7f665e1b1d13f781b5b0067"
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
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-13.0.2.tgz"
    sha256 "1b1524d914331bd01312729e31a828192d53af84e113dacb6e36afabb6c21a6d"

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
