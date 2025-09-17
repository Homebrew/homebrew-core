class Heroku < Formula
  desc "CLI for Heroku"
  homepage "https://www.npmjs.com/package/heroku/"
  url "https://registry.npmjs.org/heroku/-/heroku-10.13.2.tgz"
  sha256 "ddb663c71c06a61f9909f046373b5588db4e908e92a18d2b9dcfe437d8ead0f3"
  license "ISC"

  bottle do
    sha256                               arm64_tahoe:   "3340225ec8f2134051367b4dca953ed36afc23d5c87cfa8ef49a66c2f7d4567b"
    sha256                               arm64_sequoia: "a95beae9f6463609500489ad3d805f2eb90645c5d5be8700274b1f2d3b8b6567"
    sha256                               arm64_sonoma:  "6eea6553efb3782e65c207470dde1e7900f14354c31a87eadb3bef0f1de08e72"
    sha256                               sonoma:        "8a5fef715073aabb3314220ea5549a7def39cb515a0b34db3dcf34f6463e7f40"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "050070b0701671d76ed4820de4355d2c19eb9a5daed59bf236f854044825153e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8f4cb2775b3b5728ef99244408538e0314e754324519cf58527eeb9ae5333f3"
  end

  depends_on "node"

  on_macos do
    depends_on "terminal-notifier"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    node_modules = libexec/"lib/node_modules/heroku/node_modules"
    # Remove vendored pre-built binary `terminal-notifier`
    node_notifier_vendor_dir = node_modules/"node-notifier/vendor"
    rm_r(node_notifier_vendor_dir) # remove vendored pre-built binaries

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
