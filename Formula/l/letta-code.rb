class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.27.6.tgz"
  sha256 "af4f8b81e9d5df2a5a1b3107ff6dc081a0dfdc1f055abbd8612bdf48db592a3a"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "7d446753e00e960f92c6c56db60c115e3ea8fee881b2de2ee9026188de4456c6"
    sha256               arm64_sequoia: "70a118791029668ffbd6ec587ae83897c01811cb7ec0f3bedc82b3e7da4214c7"
    sha256               arm64_sonoma:  "c331d16b1fb703b0dac1c0f7496a52191e2ad6195d7cb2a0a3517a8b4180e5b4"
    sha256               sonoma:        "29f98f49389a22e3b6e25f7e20f35c9d320c1d00da8d05a91dff18240444be7d"
    sha256 cellar: :any, arm64_linux:   "df366325785594973a7a1c5cc30c565e7d499a30aa9f974f7ee4f2873175edc3"
    sha256 cellar: :any, x86_64_linux:  "e91fac0a99ccfe74a54af61ca75c049085fee97dfb2b5ffde70f578f257d894c"
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
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-12.4.0.tgz"
    sha256 "c5651a4fa92942a36cf30e0f043119d4889e26e25f30ae28b8cecc16e705bf29"

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
    assert_match "Locally pinned agents: (none)", output
  end
end
