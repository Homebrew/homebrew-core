class Heroku < Formula
  desc "CLI for Heroku"
  homepage "https://www.npmjs.com/package/heroku/"
  url "https://registry.npmjs.org/heroku/-/heroku-10.0.2.tgz"
  sha256 "7207911c15978505886d8acd8467457056466e3dd15887e553431e6657fec007"
  license "ISC"

  bottle do
    sha256                               arm64_sequoia: "da4855f6b361569543c5ce11c69eeafbca79ffcb05cdcf5e926e73e40919a178"
    sha256                               arm64_sonoma:  "97787e6f05d9bd716996fd41d65b90e54fe26e63c9b8d39ed4d4e673dca24388"
    sha256                               arm64_ventura: "143511f7a10fd36e6e3e059e7c9a8887ca819569c72a8e559758333c9b6a7f11"
    sha256                               sonoma:        "88880693058b4ee201765587acd4e82fe458052c448b2866fd81711e5b33c486"
    sha256                               ventura:       "6d1beb0c29afe604a4e26b33b1c761cae11849d3b8443d851d680ccdcd0cd6e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "969f43d8f6efa9ce1d78c68300d760e619b9520463d12b3ad11083d7f18c9d45"
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
