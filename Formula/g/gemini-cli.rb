class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://geminicli.com"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.67.0.tgz"
  sha256 "3f42374e88171031459ad16e5fac32b161adba330292a1822fb7aae7fb476fc2"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "93e0e741c19be79231b05624f8b5915ab6ce2d0e22d01cfb0d85c1021340e83d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0cef9e8d0c0ca714dfd1a3d5ceb0db852aa20c130f6ad25c858622cec3d2db00"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "907ddb1029b243b89d3081415a03a23813908e78182b0e17b6e4634a03480cf8"
    sha256 cellar: :any,                 arm64_linux:       "a3fd3b5f540ea0447dc0b54fe60a7720d27772166e3fb414f84388427e665544"
    sha256 cellar: :any,                 x86_64_linux:      "3dfb295e3150926582a73f4a0d65de40f093606865ba295ce0533a9f63d8ed6c"
  end

  deprecate! date: "2026-06-18", because: :unsupported, replacement_cask: "antigravity-cli"
  disable! date: "2026-12-18", because: :unsupported, replacement_cask: "antigravity-cli"

  depends_on "node"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "glib"
    depends_on "libsecret"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@google/gemini-cli/node_modules"
    cd node_modules/"@github/keytar" do
      rm_r "prebuilds"
      system "npm", "run", "build"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gemini --version")

    assert_match "Please set an Auth method", shell_output("#{bin}/gemini --prompt Homebrew 2>&1", 41)
  end
end
