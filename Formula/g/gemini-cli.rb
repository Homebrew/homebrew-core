class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://geminicli.com"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.70.0.tgz"
  sha256 "be811606fc364c5679693d686c456fa2413c50bc6174d568439b4ddb4533906b"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7c2efe02c739f8df0bf6c4c4ae1847cc265afce9c284d3f8afec5bf4008986bf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "22fd1ae4c409217c593a4d996960be95adba7dcd92a6850f7012f9cfec61136f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b13e3956016b98bb372d8010bfb5f3369975a536468d29ff9f9f8d802a69d70c"
    sha256 cellar: :any,                 arm64_linux:       "d7d8a9462ae211173377dec3bf0a64c76c36bb1975fc9eb463e0b56e87e3d29f"
    sha256 cellar: :any,                 x86_64_linux:      "2959745066688b7039d762d0170daf92f65404dfbefeb5fe523c80d29ac3d445"
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
