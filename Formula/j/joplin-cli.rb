class JoplinCli < Formula
  desc "Note taking and to-do application with synchronization capabilities"
  homepage "https://joplinapp.org/"
  url "https://registry.npmjs.org/joplin/-/joplin-3.0.1.tgz"
  sha256 "86217bd4b98a6a9e6b31ee3c716f6f83e2b90ff600bc436b47a428842494b5d4"
  license "MIT"

  bottle do
    rebuild 1
    sha256                               arm64_sequoia:  "5e5fe3221c830d5daf68074d89a1dc7e90d2ef3cef9bd109db1ebe2680c27c54"
    sha256                               arm64_sonoma:   "268c55e18469316597519d382404d819ab5cc6919add24c64f8905ade49d12b2"
    sha256                               arm64_ventura:  "0556a2e4a45eeca512fe5a84dd89e074ee6f235ee836ca368b9ae9a15de88c31"
    sha256                               arm64_monterey: "bb9f103a62ec68f52a32739e367319ff5056c2a5f11ca6006926ad348e6093da"
    sha256                               sonoma:         "bfc5d70e1b43b75510a7e76a60d26f5faec96007194116fd7e9d1f06b953e8eb"
    sha256                               ventura:        "fc3bda1b535e6c489599ffc83b1d80e949c22f6cb0919078b7e140efe5b6a664"
    sha256                               monterey:       "7e86a5257f01beb0e79aeba8cfee23baa69604f6e88e1d78cd1780790e33674e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a74a3425df0c9686ce10e748a6da188fd235f4b4ee861004a161b146e60732ae"
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
