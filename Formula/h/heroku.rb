class Heroku < Formula
  desc "CLI for Heroku"
  homepage "https://www.npmjs.com/package/heroku/"
  url "https://registry.npmjs.org/heroku/-/heroku-10.6.0.tgz"
  sha256 "f32018d8a883f22e80e4aec08f8f42ee59f53961aff1288cf7af55db65b6651d"
  license "ISC"

  bottle do
    sha256                               arm64_sequoia: "3a255c6036b793b53bb97c29105a6b61d7b437731a652841451a21101250b0e5"
    sha256                               arm64_sonoma:  "8aecaffb8dca42d16777b6af9af7a12a6a0bf1f528399c563d2ddf5a762be2ae"
    sha256                               arm64_ventura: "310f9f5d8f5f4733527da67f4f46583a32aa88eb78e5350e3562cd1eb932e5c5"
    sha256                               sonoma:        "a322246d70cb4e37aaa3dc78e21b23b822659ef1b276f793d7ae486ae8e97ff0"
    sha256                               ventura:       "961e6cb58ae87329ac4a8e6abbbae22cf3af5e2acaa31d0c0004c77ee9510091"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "768a8c7747e8e67dcc8d00bd97fb5bc558051cb35e51b8d418f41fc44b385149"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "769fedc6c311566de7022f5a766407fbe00720dac79c5ffc086bc7a7e6d2e502"
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
