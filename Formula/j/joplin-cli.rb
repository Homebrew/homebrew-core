class JoplinCli < Formula
  desc "Note taking and to-do application with synchronization capabilities"
  homepage "https://joplinapp.org/"
  url "https://registry.npmjs.org/joplin/-/joplin-3.3.1.tgz"
  sha256 "b0cc8590966d01eaa5a5d60bdec870ed51c342c80b1ebcbfb33eef222a1c4b01"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "76470d9d9c29307d8b35f53a13a7754fc6575d78386de65caaa91ab3ca9f3527"
    sha256                               arm64_sonoma:  "6f3c853e5d2f9be1bd6f0266fbb64be2c7018cbca3d3577adbd75c1f95ee538a"
    sha256                               arm64_ventura: "36d5c93be1e4e9db96eb44ea46e3d20ddc68540474e3233e57581cf35fa7b9ff"
    sha256                               sonoma:        "f18ca7fe37ccf6a4744fa00541bf8fabb95fffcc5907eb9f8403cb9d8ae91d70"
    sha256                               ventura:       "44a51b383c515b2634a21c66ac5c96d45a39832db7bb55aade89b822b44a6f39"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9fa082d02615325e6393d5d1d559c1f6243fb165240a7f7a396c23a4b235a5db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9738157fd59266c3a6622d6444de5446d3c5fdbfb1c1ef0ec983e57b3478659"
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
