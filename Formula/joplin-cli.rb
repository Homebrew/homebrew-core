require "language/node"

class JoplinCli < Formula
  desc "Note taking and to-do application with synchronization capabilities"
  homepage "https://joplinapp.org/"
  url "https://registry.npmjs.org/joplin/-/joplin-2.6.1.tgz"
  sha256 "5ae8c2cfbb54b55bba18f7cd413ba7bd7ef03412021322b65df53216fd7db4be"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "52c311d9e488d96e2e8aa4d1367311b5e27122cbf628f9394899d94cb9bd87f1"
    sha256 big_sur:       "bc1aa68c4c2df173022cf36de72838ba3fb4605d031f81b91d3f5b16d4ca9968"
    sha256 catalina:      "248fab15de1b4c16463ec33bf6b2dd9b3f7ecdc64a8e463d38530c3143e64934"
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
