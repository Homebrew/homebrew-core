class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.41.2.tgz"
  sha256 "880d45a4f86796ec21d863084a99320251c9a2a4969419a92f3313bd54246018"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_tahoe:   "ead438b1243e59c5f3305bcedde7e7f44687e712858e2d97d1f6855da946c6b8"
    sha256                               arm64_sequoia: "91fddb4caecb9246c8bd898cd029178d94809d390c0c664e95eaf125d9a5b8a3"
    sha256                               arm64_sonoma:  "6d5257b923f5b0577a34ab40c961c1979a66c8a056d366d2b20c81755fffdce7"
    sha256                               sonoma:        "b0132ddb7129964407c9ccd5cda7c7c1f8e5431366c7b069069b224947051d7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "faf8f2b7bb165ee74e19a900bd96a584b1e84758c9e0d1ec792fe96d66e2999c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4638bcf8eccea51bda2a8babbcc5bc680d125dea1a99bb5d2546f59b312cec37"
  end

  depends_on "node"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "glib"
    depends_on "libsecret"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@google/gemini-cli/node_modules"
    node_modules.glob("{bare-fs,bare-os,bare-url,tree-sitter-bash,node-pty}/prebuilds/*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}"
    end

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
