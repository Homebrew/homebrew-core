class JoplinCli < Formula
  desc "Note taking and to-do application with synchronization capabilities"
  homepage "https://joplinapp.org/"
  url "https://registry.npmjs.org/joplin/-/joplin-3.2.3.tgz"
  sha256 "7dffd1f21357f306958eed02a79ac1223e69b847ae55ddbd613fb1564f9cf2b4"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "3a0fb70e37cfacdd16fc7133f4a0339be831a945fed530e5ade41f622c7a8a21"
    sha256                               arm64_sonoma:  "b9ba88cdbbd8809006f2b8bf0a61d8cb89703213a03b3799ccb9b0b92b99990b"
    sha256                               arm64_ventura: "8dc693cfcfd51ee835358b03a1fa11db7497689aec6a8e6373b81601c15481fb"
    sha256                               sonoma:        "e31ded0565672883780bda90b5af4e0a09ade984ec18896d648d411d234719df"
    sha256                               ventura:       "e14c0abb59664e2e479cc0b98f54706702f3cc52a9ca9854991424c7abc48a58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d985598b03af1e5f55f80e87931e9d3b9e1d48f153c14693a20f25d7967c53b"
  end

  depends_on "pkgconf" => :build
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
