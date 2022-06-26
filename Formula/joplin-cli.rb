require "language/node"

class JoplinCli < Formula
  desc "Note taking and to-do application with synchronization capabilities"
  homepage "https://joplinapp.org/"
  url "https://registry.npmjs.org/joplin/-/joplin-2.8.1.tgz"
  sha256 "bf5d3e2ce4a82916e984878a6a5aa80de830307643c67c9d6641f873a6903714"
  license "MIT"

  bottle do
    sha256                               arm64_monterey: "d075896c46572bb397fb8bb33eec5397a7bd196af8428737bef136616e42d074"
    sha256                               arm64_big_sur:  "e8eab26199c344f6a370d1ebf68a925dbf6ad93746ee1ab8ee75b45a428c189c"
    sha256                               monterey:       "6ae50728292a131ee4cd2679f184d5678843e09335de8c6d24bf627194dbcf21"
    sha256                               big_sur:        "ea1da65c3f856be2849fabe36e053f15b9adb368b5b3f74779364116f7bebcae"
    sha256                               catalina:       "ff01bf2bc679496d8de250d25eacadcf59cb315082eccfafb58335fe56230e94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "712d7846deaf2b1b36ae5b6b6bfafa6929d89342dbb7634dc03bfe117d4ebc5e"
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
