class HappyCoder < Formula
  desc "Code on the go controlling claude code from your mobile device"
  homepage "https://happy.engineering/"
  url "https://registry.npmjs.org/happy-coder/-/happy-coder-0.13.0.tgz"
  sha256 "dee16a2425db6aa9db3bf017978075c8ec0984b971a864f6bfdaf7b58cc5a08c"
  license "MIT"

  depends_on "difftastic"
  depends_on "node"
  depends_on "pcre2"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args(ignore_scripts: false)
    bin.install_symlink libexec.glob("bin/*")

    # Remove bundled pre-built binaries
    unpacked = libexec/"lib/node_modules/happy-coder/tools/unpacked"
    rm_r unpacked.glob("{difft,rg}")

    unpacked.install_symlink Formula["difftastic"].opt_bin/"difft"
    unpacked.install_symlink Formula["ripgrep"].opt_bin/"rg"
  end

  test do
    output = shell_output("#{bin}/happy doctor")
    assert_match "Happy CLI Version: #{version}", output
    assert_match "Doctor diagnosis complete!", output
  end
end
