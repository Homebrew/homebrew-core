class Heroku < Formula
  desc "CLI for Heroku"
  homepage "https://www.npmjs.com/package/heroku/"
  url "https://registry.npmjs.org/heroku/-/heroku-10.11.0.tgz"
  sha256 "bfff484804011b77c4e7b3733298034d16b0d8cfd70b5ae7d2e46e6a0fa80e92"
  license "ISC"

  bottle do
    sha256                               arm64_sequoia: "5640c790b3c5aa2c18a79ab2bbc5c78bab4756c0b26992f4b77bb6adb6540b64"
    sha256                               arm64_sonoma:  "43b7023d123ac85ce0e7df9cb1c3fa5ec504245e511b3aed326d1a60721d26a2"
    sha256                               arm64_ventura: "c47303d42eb23c56821bfe0fc91fbde92b161a3932c3dd726b4da36ef0a9c4eb"
    sha256                               sonoma:        "74627fa71c8605f7ba54c4158ac44a070e66ae9c282dd40bbeb02f53a563ebb9"
    sha256                               ventura:       "6800f775444fa5e0e82c96787a699633350e6ef248200bdb03d88a01b6a19942"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "254a66588fd5c7428017695123fd8d8f172ebde1dd64b951a9c45ef5f47e4383"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a91cb6bf2f754f42d7057756bcedb2d360e0f74859edb21566490ac885bca145"
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
