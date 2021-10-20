require "language/node"

class JoplinCli < Formula
  desc "Note taking and to-do application with synchronization capabilities"
  homepage "https://joplinapp.org/"
  url "https://registry.npmjs.org/joplin/-/joplin-2.4.1.tgz"
  sha256 "f589b268195d91ba549680db0148bc07b7453dd895eec57229766d13572b0582"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "fcc4759ad2c0eaa4eea9db992a6e0995de7d4236671ae94d09b6b4fdcffb164b"
    sha256 big_sur:       "3041aa9b34b17d07ab0b48e024aa11feccb5dfc1c96e5a7f0345fefc43e81518"
    sha256 catalina:      "d99229bf20f37e4737d8be9caa3f6612c55e2c5780bac74c7813a96d44ed960c"
    sha256 mojave:        "8452721fd8a56ed9339563e2c864adc9af1eadbe1f7f3be2f1274bd999bd54ce"
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
