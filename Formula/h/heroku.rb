class Heroku < Formula
  desc "CLI for Heroku"
  homepage "https://www.npmjs.com/package/heroku/"
  url "https://registry.npmjs.org/heroku/-/heroku-10.8.0.tgz"
  sha256 "f3de9b210fa9cee0b2d4fea815b6540e151de2ea84238a12b4606734c635179a"
  license "ISC"

  bottle do
    sha256                               arm64_sequoia: "482e94277f97d64b6d9766b775a1f96d9c0a92888ab89b99ad4d1ecf1b71bd85"
    sha256                               arm64_sonoma:  "5409bdf1e315d6e37e6685eb786b8a882288febfb7ab52abfd69e726d132b3fd"
    sha256                               arm64_ventura: "dc48dbbbac66b32a9ae2f2d1387da986188a33d47cd3e049ac3156fcc2a48078"
    sha256                               sonoma:        "55d7b785ecf712b25ca9e0be6cbffdf814c2dfba8fce48081d7ed10847dbcdd8"
    sha256                               ventura:       "b31c65ba1b5e5df8b2d235b7e70e6560818b0870dc6cebef4fe6d103c921c428"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8c2d7cc8421f48304ad39e3a7228da5f6972d49504f21238e55b45cb426c675"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d227b53380b3524bcb99449bc8a05ae7284ca40902b6aa1423fda4d5f697ad6"
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
