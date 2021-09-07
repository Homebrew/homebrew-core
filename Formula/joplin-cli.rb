require "language/node"

class JoplinCli < Formula
  desc "Note taking and to-do application with synchronization capabilities"
  homepage "https://joplinapp.org/"
  url "https://registry.npmjs.org/joplin/-/joplin-2.3.2.tgz"
  sha256 "fb87056d5c47780e7420c9e3330728e05fe31d76804f80c77fe13da53d60af57"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "4b8aa6190a7409da64a4239d008e3c31068904d9617a21c7139d29a6f639a331"
    sha256 big_sur:       "f269cd3f83524e80de3030ebc5b9e94f1985b4f7233851244039f9f78b043536"
    sha256 catalina:      "c0bf82e586aa6131b1c4b47e5f19fbcf2f19a18e7a47eb75f4f04c96ad49c6df"
    sha256 mojave:        "ca05cebc82bb8d9b3e2fe815d64e608edf2fbb5c333477f580a6300390bb5f46"
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
