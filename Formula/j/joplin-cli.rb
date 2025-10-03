class JoplinCli < Formula
  desc "Note taking and to-do application with synchronization capabilities"
  homepage "https://joplinapp.org/"
  url "https://registry.npmjs.org/joplin/-/joplin-3.4.1.tgz"
  sha256 "2335d562e020ec02f90f3e538ec063712e223d1eb0e6dfe1cc76b1b95c4d1ecd"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "12dc7725a9c234140b5cea609a65d18cdb900c74f2b9550326bbfe55ca21d7e9"
    sha256                               arm64_sequoia: "1cf70bedd032058de7f272d627dbb70c13e0b6f90d3703ad9afa98516c9a0b30"
    sha256                               arm64_sonoma:  "a898216cfef39884fcf3016d586c38e626dba8f95d4ea620843aa8c3e9b180f1"
    sha256                               arm64_ventura: "02acb6adb35419e1a7205c0234814affcb98d09b08a0083ed1632161bd355d03"
    sha256                               sonoma:        "cffe1fbab33a9e286fbaa4f994b8e3d3506e51db4238c6be788dcdd21851be7d"
    sha256                               ventura:       "941d81af5c1c7d3c7985227749541b2b2b908f403477cd81dc6a341c94f77b89"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44e3d23534cce854d43376e86e23f9af2986b0ca703d978f2c8f7a7b9afebbb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "863b59cdca473293dbf6a0da3aa6e60accf4b84cd4b679f5b91e20b2d501da99"
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
