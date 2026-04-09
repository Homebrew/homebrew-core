class JoplinCli < Formula
  desc "Note taking and to-do application with synchronization capabilities"
  homepage "https://joplinapp.org/"
  url "https://registry.npmjs.org/joplin/-/joplin-3.5.1.tgz"
  sha256 "28182c1e0a2cf8ea05af62a3b7bf732a32d4872afb35346356bcd42bae25b3ab"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "4c814f93dde7c7aec94b51f2747700986fb2792215c8ab6d7689f99456df414f"
    sha256                               arm64_sequoia: "0972a4c594197e043f10ad8b603141523e1baac35fc75ba654a9f9a0d6137c51"
    sha256                               arm64_sonoma:  "cd72755f17716d535812daf624f3fb650f459352568f39fb0a86ab92305548bf"
    sha256                               sonoma:        "da78de3b3d94131a52bbba1379b2eeeb4cc25fed188afa97e78e105fab24b65d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a90ee5357fc60e44d44175c9b88a32ce05acd0e6e0afda3301d79a0049a23588"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7410c5b61863a8f7547ab4b979bdebcff44a658512bdb7681f1c70a8268b912e"
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
    system "npm", "add", "node-addon-api@8.0.0"
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_notifier_vendor_dir = libexec/"lib/node_modules/joplin/node_modules/node-notifier/vendor"
    rm_r(node_notifier_vendor_dir) # remove vendored pre-built binaries

    if OS.mac?
      terminal_notifier_dir = node_notifier_vendor_dir/"mac.noindex"
      terminal_notifier_dir.mkpath

      # replace vendored terminal-notifier with our own
      terminal_notifier_app = Formula["terminal-notifier"].opt_prefix/"terminal-notifier.app"
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
