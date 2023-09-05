require "language/node"

class JoplinCli < Formula
  desc "Note taking and to-do application with synchronization capabilities"
  homepage "https://joplinapp.org/"
  url "https://registry.npmjs.org/joplin/-/joplin-2.12.1.tgz"
  sha256 "257b23c511f5b54e533ae2fcb6ed2796205ad52fb9003b987c7546254e7371ba"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "5464a404afcaf28400743113b40539c3fade8f7f7bdac3e9ac16dcc89b3b3ca4"
    sha256                               arm64_monterey: "fc9fc97408e1ad88e924b030a2f97b28d26af76735489124ffb5d6eaa9f57e83"
    sha256                               arm64_big_sur:  "64a64501dc9ae34f45eb17e910c3b3eee2790d3300a479c29d5ab9c8a345ce32"
    sha256                               ventura:        "27e833410ab4ca2cfbc186aac58f368db2d72f29e8cc11e226844da43327c949"
    sha256                               monterey:       "743c535faf7a38ef6f7af36b47230417580fdc583537d7ea0368b7d8cd2956d0"
    sha256                               big_sur:        "cd92eebbee2591622a751a2c08a9d9cf1526b56d2766045ba45eb41b817b1abc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "485e9ad92ec32ea04fc8627ef3aeb1763d2fbe4283d6b554cc36d79d5ae53615"
  end

  depends_on "pkg-config" => :build
  depends_on "node"
  depends_on "sqlite"
  depends_on "vips"

  on_macos do
    depends_on "terminal-notifier"
  end

  on_linux do
    depends_on "libsecret"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    node_notifier_vendor_dir = libexec/"lib/node_modules/joplin/node_modules/node-notifier/vendor"
    node_notifier_vendor_dir.rmtree # remove vendored pre-built binaries

    if OS.mac?
      terminal_notifier_dir = node_notifier_vendor_dir/"mac.noindex"
      terminal_notifier_dir.mkpath

      # replace vendored terminal-notifier with our own
      terminal_notifier_app = Formula["terminal-notifier"].opt_prefix/"terminal-notifier.app"
      ln_sf terminal_notifier_app.relative_path_from(terminal_notifier_dir), terminal_notifier_dir
    end

    # Replace universal binaries with their native slices
    deuniversalize_machos libexec/"lib/node_modules/joplin/node_modules/fsevents/fsevents.node"
  end

  # All joplin commands rely on the system keychain and so they cannot run
  # unattended. The version command was specially modified in order to allow it
  # to be run in homebrew tests. Hence we test with `joplin version` here. This
  # does assert that joplin runs successfully on the environment.
  test do
    assert_match "joplin #{version}", shell_output("#{bin}/joplin version")
  end
end
