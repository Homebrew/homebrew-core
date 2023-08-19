require "language/node"

class JoplinCli < Formula
  desc "Note taking and to-do application with synchronization capabilities"
  homepage "https://joplinapp.org/"
  url "https://registry.npmjs.org/joplin/-/joplin-2.11.1.tgz"
  sha256 "dc37ee5ed50ddf133d6b4b575f48f6b07ff6e2effc3f1c96b690443111bacc7f"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "00c4aa2e1eeef4d3b4ebb653eb4bd09ecbecce592c6116e403418a35e045fa9d"
    sha256                               arm64_monterey: "e8c0a950d3385bc339b1b4c60855870d680ceb71f74d1eb55761100f17c85984"
    sha256                               arm64_big_sur:  "239536e72fbfe8c4573babc207ca11158f338f9bde80becd0b69e1de1756e142"
    sha256                               ventura:        "ad13fe2184fab4841bb9363203504d1f83c7a8f44f8c1b6d251eadebed086ae9"
    sha256                               monterey:       "9f9ce8a8f3a7a09b5237d24157b41aaac6a8ec6fdeda6808857171ce88a3f699"
    sha256                               big_sur:        "c1771e720b4541f279d5e47b50bd5722d463be9cc4c45b605dd9321f4f004e89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e458c9d698d09f280b2dae8be6a333d9b827f0ca31c1489ad8644f0f2ebec68"
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
