class Heroku < Formula
  desc "CLI for Heroku"
  homepage "https://www.npmjs.com/package/heroku/"
  url "https://registry.npmjs.org/heroku/-/heroku-11.8.0.tgz"
  sha256 "4ff3e8c16937f29c12ba150575854623b7e59050f7d0a0406839eeb6285eae55"
  license "ISC"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5f69596b48f88dc146ac1110937503b68fdcaee9c8a593d27c986377583c33e2"
    sha256 cellar: :any, arm64_sequoia: "e5a3259bbe60446067bf187acd139bd4991870c29955faba5fde9e3f69dbb582"
    sha256 cellar: :any, arm64_sonoma:  "e5a3259bbe60446067bf187acd139bd4991870c29955faba5fde9e3f69dbb582"
    sha256 cellar: :any, sonoma:        "f86570c4be6926ae35681969c3f62500156c44013553453723e8a2b469120fc1"
    sha256 cellar: :any, arm64_linux:   "e639de815c6ffdced7e9d3be448cbca631e1511b7375d18365e57e774b073b92"
    sha256 cellar: :any, x86_64_linux:  "1b3683763c04b3d691d001b7d5fff67a0a745e880ee59239f3f7e8c004b9ee3b"
  end

  depends_on "node"

  on_macos do
    depends_on "terminal-notifier"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/heroku/node_modules"
    # Remove vendored pre-built binary `terminal-notifier`
    node_notifier_vendor_dir = node_modules/"node-notifier/vendor"
    rm_r(node_notifier_vendor_dir) # remove vendored pre-built binaries

    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    if OS.mac?
      terminal_notifier_dir = node_notifier_vendor_dir/"mac.noindex"
      terminal_notifier_dir.mkpath

      # replace vendored `terminal-notifier` with our own
      terminal_notifier_app = formula_opt_prefix("terminal-notifier")/"terminal-notifier.app"
      ln_sf terminal_notifier_app.relative_path_from(terminal_notifier_dir), terminal_notifier_dir
    end

    # Replace universal binaries with their native slices.
    deuniversalize_machos
  end

  test do
    assert_match "Error: not logged in", shell_output("#{bin}/heroku auth:whoami 2>&1", 100)
  end
end
