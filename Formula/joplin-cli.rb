require "language/node"

class JoplinCli < Formula
  desc "Note taking and to-do application with synchronization capabilities"
  homepage "https://joplinapp.org/"
  url "https://registry.npmjs.org/joplin/-/joplin-2.10.3.tgz"
  sha256 "5aec982e1fb0dbfb43bb783bb145a9f2694128b87bf3f328bd0c1f634edbb72d"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "de663d43417145c50a6c36a2a0b0dc3edb7c27203cafeb6bb3633d79dca4bec9"
    sha256                               arm64_monterey: "0072f256ceb84d63dc64ba2c65622312d866b3d62c3e84dfac33149be74015b5"
    sha256                               arm64_big_sur:  "0c7fed5aadcf9cb9f692c705bfaadc0381371d728e4dd33037dd80b3d5aba69d"
    sha256                               ventura:        "88c3929dd70d488d9bc5f1b04a00b5b570048ffe89dbedce7af904d129e1b69a"
    sha256                               monterey:       "e011d2ea1c3e494f71ada233e611a20290cbc389c49364166bd3700feb09be90"
    sha256                               big_sur:        "d19763039c84722ac655c85becc6803c2f21314e51be77b357a0a17470e1e093"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e18d19bcf807502f2e02daa15823cbf9f86cbfffea95a2783ef931de1e1dcaa"
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
