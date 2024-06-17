require "language/node"

class JoplinCli < Formula
  desc "Note taking and to-do application with synchronization capabilities"
  homepage "https://joplinapp.org/"
  url "https://registry.npmjs.org/joplin/-/joplin-2.14.1.tgz"
  sha256 "76241726ebe5f53261d5723d289067e891d546a7689b3371a172faf3675ba286"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "7c6224827db70109779b944a8f3dd9ea0583d16845d730a36d548c1ffd37d32d"
    sha256                               arm64_ventura:  "3e85a370bc6ce220083176ef036931a2c0d6232990bfad0d993ed89e52a68cbd"
    sha256                               arm64_monterey: "d81619be1f83512ba84ab964a76a7048431381e412473b01f683c4fd7b524109"
    sha256                               sonoma:         "c0a9e76e12227f288905340b5a48c63f2fee1853170b4872af635a7d83ed1751"
    sha256                               ventura:        "fb0123c36c29a1d7714f23179a11bdb7d199ba73b6c0afd1f803ea9663baa20b"
    sha256                               monterey:       "f9e59afa2d54cbc9b2c013fa43b360cafec3d611098582a66ff5afa0778674db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03a680f09a6a3e93bb43ee844dbaffaa4abc91dd7cfd5dd6a0b488b2fa131895"
  end

  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build # for node-gyp
  depends_on "python@3.12" => :build
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
  end

  # All joplin commands rely on the system keychain and so they cannot run
  # unattended. The version command was specially modified in order to allow it
  # to be run in homebrew tests. Hence we test with `joplin version` here. This
  # does assert that joplin runs successfully on the environment.
  test do
    assert_match "joplin #{version}", shell_output("#{bin}/joplin version")
  end
end
