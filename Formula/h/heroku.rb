class Heroku < Formula
  desc "CLI for Heroku"
  homepage "https://www.npmjs.com/package/heroku/"
  url "https://registry.npmjs.org/heroku/-/heroku-10.6.1.tgz"
  sha256 "1f8b90343ff6299d14a6e7983a97176fb9a22ffb32ee4f3e732cecfee32cf311"
  license "ISC"

  bottle do
    sha256                               arm64_sequoia: "06c478068a973870d3e76f87a54b7ebf0987ad7cda37aab3756c8fb2df6f5a12"
    sha256                               arm64_sonoma:  "cabafb851bb5a4aeb9607284c44d3228106fa6065e741e4fe42592b691d6ff7c"
    sha256                               arm64_ventura: "9a8f4d892bcdbd918d623721063ec8ff1695f90a51c0adc2c2c9804b92f70e72"
    sha256                               sonoma:        "ec1418eb293c34814673b8ee8aa65ff2e5e64beab502b4300a8fb7f4f5dd98c4"
    sha256                               ventura:       "438abf83aac0eb456d2b931ffccf3ca61878ebeaddfb92431f01b0feff1afe0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e05f6f0b76b8b6b6a953ee31100135d15b78a85c251b49a042d5f5770160c989"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08e37a3d64be7aedcd17933cd3a1c16ee2e261cb74c331eee35a01b4c9a60788"
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
