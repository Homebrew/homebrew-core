class Heroku < Formula
  desc "CLI for Heroku"
  homepage "https://www.npmjs.com/package/heroku/"
  url "https://registry.npmjs.org/heroku/-/heroku-11.7.1.tgz"
  sha256 "7e6b8eeaf4f6ef49ed26a7e74509a3883b3f6a5de4e1682bc719067d19f9ad1a"
  license "ISC"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3c888754baf3377e0550f32dde632196549ded291bd060d45103e1bfad54c796"
    sha256 cellar: :any, arm64_sequoia: "dc41f5c2e35828a1a64f39315f2b834c20d95e9fe1e58553fc37d7e799579e41"
    sha256 cellar: :any, arm64_sonoma:  "dc41f5c2e35828a1a64f39315f2b834c20d95e9fe1e58553fc37d7e799579e41"
    sha256 cellar: :any, sonoma:        "bfb19513f2954a1a2a4d6f0652c6c6de45693c0d8f8afdd1d3dc4040c101458c"
    sha256 cellar: :any, arm64_linux:   "3ea3164777476cdd12872c294385c9ca15aae92435e491c04d4be57e26707a87"
    sha256 cellar: :any, x86_64_linux:  "ad7c49dd2075683d404a48860b2e952cf25a93d8c294542fc7e63f67b0740ba9"
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
