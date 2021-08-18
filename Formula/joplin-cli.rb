require "language/node"

class JoplinCli < Formula
  desc "Note taking and to-do application with synchronization capabilities"
  homepage "https://joplinapp.org/"
  url "https://registry.npmjs.org/joplin/-/joplin-2.3.2.tgz"
  sha256 "fb87056d5c47780e7420c9e3330728e05fe31d76804f80c77fe13da53d60af57"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "737d8e92d1a6a69650704bbe54a469d65d5f5c00d25f41207137e88f56d690e9"
    sha256 big_sur:       "285bb0d87c467021358f9446fa7e23be996dda465789fee0cc7bf4cdaaaacfc2"
    sha256 catalina:      "381ff38930df7996d29d972c8eee3785524273e2f20ef411575a33d61d236c96"
    sha256 mojave:        "6ff8a5eea10a3b871d41c3df388fc76b5e255606c765c2aae16d3c1b408e6c53"
  end

  depends_on "pkg-config" => :build
  depends_on "node"
  depends_on "sqlite"
  depends_on "vips"

  on_macos do
    depends_on "terminal-notifier"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    node_notifier_vendor_dir = libexec/"lib/node_modules/joplin/node_modules/node-notifier/vendor"
    node_notifier_vendor_dir.rmtree # remove vendored pre-built binaries

    on_macos do
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
