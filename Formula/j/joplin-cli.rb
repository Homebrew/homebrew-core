class JoplinCli < Formula
  desc "Note taking and to-do application with synchronization capabilities"
  homepage "https://joplinapp.org/"
  url "https://registry.npmjs.org/joplin/-/joplin-3.7.1.tgz"
  sha256 "18bc5b28bcfc6c5a418871e86d075015b5a83afc075dbea994fa26a40a765b56"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1f01e130ff52d36091c70ed66f7e9a295903334aa9e94d3ec43dbf315b70d28e"
    sha256 cellar: :any, arm64_tahoe:       "603a6389e61af84a635f36b39563e33832f3e4ff04e6fdf336544cef573b3aee"
    sha256 cellar: :any, arm64_sequoia:     "557862a881e2557577d9e3a83d77f3a220b06e3717fe7d0ca0c8eab5805e90bb"
    sha256 cellar: :any, arm64_sonoma:      "c6e69de4c392fbab9aa4ecb9aa76865e93a2d8c6c725b944d8e358b2bf13dc4b"
    sha256 cellar: :any, arm64_linux:       "614e68953a8a7cc2972b3083cee965e6b5c5918e9d74a9d211eeac55d009e145"
    sha256 cellar: :any, x86_64_linux:      "cc58c74c29f59f35e7259c1a0bab4d5742cc5bf8019c490f712b35074fd8efa5"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "node"
  depends_on "sqlite"
  depends_on "vips"

  on_macos do
    depends_on "gettext"
    depends_on "terminal-notifier"
  end

  on_linux do
    # Workaround for old `node-gyp` that needs distutils.
    # TODO: Remove when `node-gyp` is v10+
    depends_on "python-setuptools" => :build
    depends_on "libsecret"
  end

  def install
    # Need node-addon-api v7+: https://github.com/lovell/sharp/issues/3920
    system "npm", "add", "node-addon-api@8.9.0"
    system "npm", "install", *std_npm_args(ignore_scripts: false)
    bin.install_symlink libexec.glob("bin/*")

    node_notifier_vendor_dir = libexec/"lib/node_modules/joplin/node_modules/node-notifier/vendor"
    rm_r(node_notifier_vendor_dir) # remove vendored pre-built binaries

    if OS.mac?
      terminal_notifier_dir = node_notifier_vendor_dir/"mac.noindex"
      terminal_notifier_dir.mkpath

      # replace vendored terminal-notifier with our own
      terminal_notifier_app = formula_opt_prefix("terminal-notifier")/"terminal-notifier.app"
      ln_sf terminal_notifier_app.relative_path_from(terminal_notifier_dir), terminal_notifier_dir
    end
  end

  # All joplin commands rely on the system keychain and so they cannot run
  # unattended. The version command was specially modified in order to allow it
  # to be run in homebrew tests. Hence we test with `joplin version` here. This
  # does assert that joplin runs successfully on the environment.
  test do
    assert_match "joplin #{version}", shell_output("#{bin}/joplin version")
  end
end
