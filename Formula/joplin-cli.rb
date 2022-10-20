require "language/node"

class JoplinCli < Formula
  desc "Note taking and to-do application with synchronization capabilities"
  homepage "https://joplinapp.org/"
  url "https://registry.npmjs.org/joplin/-/joplin-2.9.1.tgz"
  sha256 "acf001153c18cb8125895119ac5011d53a585cb5715f620a3fb9d2aff7c32d38"
  license "MIT"

  bottle do
    sha256                               arm64_monterey: "28d6793cd386cfc2bd8e58ec7a7b4b26f1c52b8fcc65d3f461388a7b52b89794"
    sha256                               arm64_big_sur:  "297b9a9322784b10e26bf452a7292b6391e5c2da2f742639f6f2a311da9fcfc4"
    sha256                               monterey:       "c1c6edfb7a1a55222aae694b07dd9bca8534f5eccbe0b729f24e55e989941704"
    sha256                               big_sur:        "73a18cdab03e94b00f3d1ca2aadf760e05c01942659ab1c293bd27f55c7783c9"
    sha256                               catalina:       "7cd5a4470f986c380025dcb129f8488419b90c565616849cfe6cd3f541551272"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55f34c94997ae0bee23826a25cd56d578cc3a74a576aa8baf1d4762a9d254915"
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
