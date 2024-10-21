class JoplinCli < Formula
  desc "Note taking and to-do application with synchronization capabilities"
  homepage "https://joplinapp.org/"
  url "https://registry.npmjs.org/joplin/-/joplin-3.0.1.tgz"
  sha256 "86217bd4b98a6a9e6b31ee3c716f6f83e2b90ff600bc436b47a428842494b5d4"
  license "MIT"

  bottle do
    rebuild 2
    sha256                               arm64_sequoia: "ef52961768cf19e1ae2b2fe9ae69e0d45e55fd06eae126e3cedfb19bc8f8ddf1"
    sha256                               arm64_sonoma:  "87e1f9bd03fa1eca5a6680739cd6cbd76872750194dca1bdba2593e3e8addf52"
    sha256                               arm64_ventura: "25fc7404867f2ea85f84a37ce14bb81eee7d3f4e4eabfd0db0be60e3b1a6910d"
    sha256                               sonoma:        "dd3f5f4c75acb229cd3145a733ede897363144e029845b3a50193e460012e1ff"
    sha256                               ventura:       "cb4c150b0a7ec1fecc06804fe287d863d9f80e6ad734a914258f4d7fd9a1b6be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b1f734064440c1e742dbeb9bc55c4f633c1393783b70fc88deec51a990abeeb"
  end

  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build # for node-gyp
  depends_on "python@3.13" => :build
  depends_on "glib"
  depends_on "node"
  depends_on "sqlite"
  depends_on "vips"

  on_macos do
    depends_on "gettext"
    depends_on "terminal-notifier"
  end

  on_linux do
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
