class Lynkr < Formula
  desc "Self-hosted Claude Code proxy with multi-provider support"
  homepage "https://github.com/vishalveerareddy123/Lynkr"
  url "https://registry.npmjs.org/lynkr/-/lynkr-5.0.1.tgz"
  sha256 "54ac554d27b53799f5d7cdfa3ec53ff1a51c7f069ec90bfbaea14ff746a25576"
  license "Apache-2.0"

  depends_on "node"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version < 1700
  end

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version < 1700)
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match "proxy", shell_output("#{bin}/lynkr --help")
  end
end
