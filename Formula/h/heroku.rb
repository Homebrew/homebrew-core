class Heroku < Formula
  desc "CLI for Heroku"
  homepage "https://www.npmjs.com/package/heroku/"
  url "https://registry.npmjs.org/heroku/-/heroku-11.0.0.tgz"
  sha256 "80ece35e332a671e2830bd56166ed52e159b4ca4d6384d3170b58b5cdcffc24e"
  license "ISC"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7df15d2c2a03127448a792ee6502d3f25270d5ac1a5b9004e824cd0c49e7cd52"
    sha256 cellar: :any,                 arm64_sequoia: "b1ee6da91792e6ba526cc42501c221b83e75d453a32b61cb6789ab5e23fdead7"
    sha256 cellar: :any,                 arm64_sonoma:  "b1ee6da91792e6ba526cc42501c221b83e75d453a32b61cb6789ab5e23fdead7"
    sha256 cellar: :any,                 sonoma:        "efb643af276822ea73eb7a05b94220605f854e0484b55247bd0e2b809af55201"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a83887ab71c4ac8efcf2dadd625e26ed56affc635349d4ca711304920d74555a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db4a3c44f66424d4b239eb17c168cdaaccf3fef0ba2c10160697bfac3d4d91e9"
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
      terminal_notifier_app = Formula["terminal-notifier"].opt_prefix/"terminal-notifier.app"
      ln_sf terminal_notifier_app.relative_path_from(terminal_notifier_dir), terminal_notifier_dir
    end

    # Replace universal binaries with their native slices.
    deuniversalize_machos
  end

  test do
    assert_match "Error: not logged in", shell_output("#{bin}/heroku auth:whoami 2>&1", 100)
  end
end
