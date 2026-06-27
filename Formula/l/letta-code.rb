class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.27.17.tgz"
  sha256 "c1416d545859a3e90c13818af67853ae9a5881151b823166f6a082fa6a3e3ab2"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "570950ed7abe8ad58ff26137aa45772abdd4db5a5474c5207871ff146cd0913e"
    sha256               arm64_sequoia: "0d41e6444e7957796e25b8f79d720f3e941abd0871ad3edcb9704e92ad1f16f2"
    sha256               arm64_sonoma:  "2569e4947a0517647c60e2915d5dc493b4f58f4c3d2e67e63ac7cd8460b1f862"
    sha256               sonoma:        "14fa0ef6675c3f0a3a72848a06a65b565e9aceb56e683ed07d1458c7efcda8c5"
    sha256 cellar: :any, arm64_linux:   "7a5f219c65350185a1b4b8580b7d70bd073a5aefd64f514b6dea4473bd67513e"
    sha256 cellar: :any, x86_64_linux:  "be3945e438042e62648757c3ba20a968785f538720e2450eea37b219a7205d97"
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
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-13.0.0.tgz"
    sha256 "10e45f33997680c9ea6ebfb8c575aba66bfbe8ad9c782a7426a37440b28b62a6"

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
