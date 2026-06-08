class JoplinCli < Formula
  desc "Note taking and to-do application with synchronization capabilities"
  homepage "https://joplinapp.org/"
  url "https://registry.npmjs.org/joplin/-/joplin-3.6.2.tgz"
  sha256 "909656e86f66014c47520fa6453deeb13c9f724044a5c7311c83167305e951e5"
  license "MIT"

  bottle do
    sha256               arm64_tahoe:   "2a3d3d848132f43555617067b2cb07a1e1a22d2559872e08f608ec25a34762d4"
    sha256               arm64_sequoia: "8d326f547af34305e48ea35b81ff727d5cb47229c3aaa968541d07527aa2779c"
    sha256               arm64_sonoma:  "9c92138d6768cac7b7c7f3e058cdceefae37222e87160ac9243a5ae5a879ccf9"
    sha256               sonoma:        "e48a04ac906216d2b5993183b14213fd1287d5bd36e4421312a96aac122e6a30"
    sha256 cellar: :any, arm64_linux:   "a7f8a626568e486d22123ef5dde63ea942171a024505fff54b22c6088e847df9"
    sha256 cellar: :any, x86_64_linux:  "6b45e5a47646286de124317a1d0055836a7f97f25615cd4044261c3454658d6f"
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
    inreplace "command-version.js", "require('../package.json')", "require('./package.json')"
    # Need node-addon-api v7+: https://github.com/lovell/sharp/issues/3920
    system "npm", "add", "node-addon-api@8.0.0"
    system "npm", "install", *std_npm_args(ignore_scripts: false)
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
