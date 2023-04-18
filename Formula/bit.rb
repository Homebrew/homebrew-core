require "language/node"

class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://bit.dev"
  url "https://registry.npmjs.org/bit-bin/-/bit-bin-14.8.8.tgz", using: :homebrew_curl
  sha256 "25d899bacd06d77fad41026a9b19cbe94c8fb986f5fe59ead7ccec9f60fd0ef9"
  license "Apache-2.0"
  revision 1
  head "https://github.com/teambit/bit.git", branch: "master"

  bottle do
    sha256                               arm64_ventura:  "c61128513cd41645552e4438d6f86f6cd96778c77ca29aa4be380a7d0ff9bfe9"
    sha256                               arm64_monterey: "25d35baef7bc17a6a2ab9d8f3083925f07c18dd40fa3c79c03e1a1eaeeab12fe"
    sha256                               arm64_big_sur:  "4aef1c99d8073edb373e209c739a490c87c8956434e242aa8fd393419ba3baf7"
    sha256                               ventura:        "ac8fc4aaef48145d1ceed6bbdaa63b58f2b6c993bf65a1ca29817154c04f108b"
    sha256                               monterey:       "1b4cefb9480be0579cc849bed266ee8602d5d074f280c9e2c88c47ed28ac3404"
    sha256                               big_sur:        "387868e05ed7c459fde2b0d7c6eb31f889002bfb2628fa54bcc8a33b91f3c6de"
    sha256                               catalina:       "c8122cc1152f05f8daf5087cc02e864d68246412180c927bca1d2cd06123ac70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c52d219252d60ad76c2cae5d1358d24d4e1de6b787beb6cf53832b972e89adcc"
  end

  depends_on "node"

  on_macos do
    depends_on "terminal-notifier"
  end

  conflicts_with "bit-git", because: "both install `bit` binaries"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/bit-bin/node_modules"
    (node_modules/"leveldown/prebuilds/linux-x64/node.napi.musl.node").unlink
    (node_modules/"leveldown/prebuilds").each_child { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }

    # Remove vendored pre-built binary `terminal-notifier`
    node_notifier_vendor_dir = node_modules/"node-notifier/vendor"
    node_notifier_vendor_dir.rmtree # remove vendored pre-built binaries

    if OS.mac?
      terminal_notifier_dir = node_notifier_vendor_dir/"mac.noindex"
      terminal_notifier_dir.mkpath

      # replace vendored `terminal-notifier` with our own
      terminal_notifier_app = Formula["terminal-notifier"].opt_prefix/"terminal-notifier.app"
      ln_sf terminal_notifier_app.relative_path_from(terminal_notifier_dir), terminal_notifier_dir
    end

    # Replace universal binaries with their native slices.
    deuniversalize_machos
  end

  test do
    (testpath/"Library/Caches/Bit/config/config.json").write <<~EOS
      { "analytics_reporting": false, "error_reporting": false }
    EOS
    output = shell_output("#{bin}/bit init --skip-update")
    assert_match "successfully initialized", output
  end
end
