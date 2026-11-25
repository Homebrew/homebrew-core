class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://geminicli.com"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.71.0.tgz"
  sha256 "d80135d4028598cb19cd92f66b531795bfb5801968bfe77e347b78cf1ae9a486"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    manifest_sha256 "d06c42a6ef455a1c6dba1f9ffda18d40fbec3efe3667b081f605cd71e9463497"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "15ea02e96a7a61b51c46b258175940f83d7ba8c7dc22f33717666afbe1cf318b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6d8a06b4783b28f86f86387a87a68a7385d25428130971723210a54ac50cdb12"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f76c0c0d44ff793f52bf9f0dd69365817ac44537713be28abb7a211164849fb7"
    sha256 cellar: :any,                 arm64_linux:       "b79729b0af94262b5bb597caee50dcb06f792948c28511ade774d04e05956f4c"
    sha256 cellar: :any,                 x86_64_linux:      "ebf6afa7e99dc59a4ea864afae71783050981e747b76ceefa298af595bb6eabd"
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
