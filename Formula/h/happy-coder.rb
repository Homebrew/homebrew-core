class HappyCoder < Formula
  desc "CLI for operating AI coding agents from mobile devices"
  homepage "https://github.com/slopus/happy-cli"
  url "https://github.com/slopus/happy-cli/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "42e1281f806aa2e604d684853213e4936f2424ea220e90f2cd6c06f4f37f297d"
  license "MIT"
  head "https://github.com/slopus/happy-cli.git", branch: "main"

  depends_on "yarn" => :build
  depends_on "difftastic"
  depends_on "node"
  depends_on "ripgrep"

  def install
    # Remove bundled binary archives before build
    rm_r "tools/archives"

    system "yarn", "install", "--immutable", "--ignore-scripts"
    system "yarn", "build"
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Create tools/unpacked with symlinks to Homebrew versions
    unpacked = libexec/"lib/node_modules/happy-coder/tools/unpacked"
    unpacked.mkpath
    unpacked.install_symlink Formula["difftastic"].opt_bin/"difft"
    unpacked.install_symlink Formula["ripgrep"].opt_bin/"rg"
  end

  test do
    output = shell_output("#{bin}/happy doctor")
    assert_match version.to_s, output
    assert_match "Doctor diagnosis complete!", output
  end
end
