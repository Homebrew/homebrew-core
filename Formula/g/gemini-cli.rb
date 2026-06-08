class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.45.2.tgz"
  sha256 "ccf71663720170c34dc4254b82d82424f1fa81a23ab2f00f608ec8588777c683"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "739c7e2461ab9949b5895feb27c9890e4ebe3e2ca5041a7a835225e3f000c5cc"
    sha256               arm64_sequoia: "d9171e410954a0658923b32a26efefbbb6eda0fe79977906b829ca2feefb7faf"
    sha256               arm64_sonoma:  "e0d96c77d3919556bf5756b2106fd0688bf238a332d5dbbe37f599344bf1673d"
    sha256               sonoma:        "751cff8de6fceb4c1319d5a792528e4def06e793d49c4ec2a61eb9c1a7e8235c"
    sha256 cellar: :any, arm64_linux:   "80df4f26c9bdd1f8a5c8671e65248b4e1ecad469c3aea44764aa1e373ba77bbe"
    sha256 cellar: :any, x86_64_linux:  "be9d67822627dd21342ac80cd7de171ebed5975ed2d741c5fded2e531d33c63b"
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
