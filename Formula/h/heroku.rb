class Heroku < Formula
  desc "CLI for Heroku"
  homepage "https://www.npmjs.com/package/heroku/"
  url "https://registry.npmjs.org/heroku/-/heroku-11.2.0.tgz"
  sha256 "913985f259f8a02fff10cefbb34d7a92d9280b472eff1978c62537a7572372a4"
  license "ISC"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8a43eb4b78795db5cc15d0b42e50f4ca918ef9800ff36ac8eda12b42d3b429ad"
    sha256 cellar: :any,                 arm64_sequoia: "2ba7f36f6765396fad39cbab76c7bc97824cea53154e23099e9d21d38b8011d3"
    sha256 cellar: :any,                 arm64_sonoma:  "2ba7f36f6765396fad39cbab76c7bc97824cea53154e23099e9d21d38b8011d3"
    sha256 cellar: :any,                 sonoma:        "ccb54a6159021730cbff71afeacc249bae97bfe850a8ab09bef138b4ad4b2f0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0bfea66fa42f357bec2e00b3f4c04a99259563791e7e40f219c0010cf0fc6e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ebd2c859580e38f631737923471dd0cc57d7b467b578260476007dfae5ed118"
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
