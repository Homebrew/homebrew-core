class Heroku < Formula
  desc "CLI for Heroku"
  homepage "https://www.npmjs.com/package/heroku/"
  url "https://registry.npmjs.org/heroku/-/heroku-10.15.1.tgz"
  sha256 "10a7ff81b3287f0fd55b6dde45ee919dfaa8d00277955e55ff97a8ff4efd5049"
  license "ISC"

  bottle do
    sha256                               arm64_tahoe:   "ae7ca75baceed6a4be4ede037ec384369452da117a88ffffe40119769ced43d0"
    sha256                               arm64_sequoia: "d48593d8c75fef1992535bb3529d22ced6a2d365f6fbb9de9e8e0cbd63bfd076"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91d7feae6a696f7ef5b322dfa1b0bd7ed071b9f2e5a059c1b95a5a8ad8df168f"
    sha256 cellar: :any_skip_relocation, sonoma:        "42f9d4c0c6faaae25b16f0761d4f6f75caf43d6300f263bc223ac0226efb75fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1658040d941a6e8d0c9d86b6363dd6a06d8efc39c2889bc2f5954860e3ff877a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd87ab6b5db3ba6bf0a2b15a0aa0127ff27e65e421ba027b1ad8ffc15559b2d5"
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
