require "language/node"

class JoplinCli < Formula
  desc "Note taking and to-do application with synchronization capabilities"
  homepage "https://joplinapp.org/"
  url "https://registry.npmjs.org/joplin/-/joplin-2.10.3.tgz"
  sha256 "5aec982e1fb0dbfb43bb783bb145a9f2694128b87bf3f328bd0c1f634edbb72d"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "5556b6709dd4db8a4d8064ce2a54f1ddd07c5d00abea9194d02e0f2a9d8927e5"
    sha256                               arm64_monterey: "b8e013eb639ce19b25d953b2a424e509c310352aeea19e2ded92edd71cc91f32"
    sha256                               arm64_big_sur:  "61f390ff90c5c947f05181ebfd319e28355d16514c6d3a0199c8871e69133d41"
    sha256                               ventura:        "70391bce3f41d5d708f40ed505df1e5fd8732c7af420b6608cc0c7be784bc891"
    sha256                               monterey:       "4524914052bd3c74ae5249e38874036505b3697c3a8cbb22bbe0b7a27d7d6265"
    sha256                               big_sur:        "cd9a4173b67ad9c8cde78929677043a02f63b2d1f0880ccd43006c1a0bc08cad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b49f950ea0547f5dadb1064bed57f80163991822cca8b3e24cedfe75d2988822"
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
