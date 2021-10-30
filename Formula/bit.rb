require "language/node"

class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://bit.dev"
  url "https://registry.npmjs.org/bit-bin/-/bit-bin-14.8.8.tgz"
  sha256 "25d899bacd06d77fad41026a9b19cbe94c8fb986f5fe59ead7ccec9f60fd0ef9"
  license "Apache-2.0"
  revision 1
  head "https://github.com/teambit/bit.git", branch: "master"

  bottle do
    sha256 arm64_big_sur: "616bf52a2d9e825320d9aab1af3603ee79e43f6d1455abd09576691049b70f0e"
    sha256 big_sur:       "9d6e88c37d303bd76cc3bc62691dade7ce1343995163c2849061a88e91ab5ef1"
    sha256 catalina:      "bc1b85c6100f4c5166eda34de5a92b66d73f45336536ed08921926dbb90ef6d8"
    sha256 mojave:        "c9fe18470becb44f6580e36bd3e9bc52219a1d4f111d271382942304c435cd86"
    sha256 high_sierra:   "2e2f871d7759adb7d2772a8ec319c3762c3e54e58625172f4ad44132cbdf3b2b"
  end

  depends_on arch: :x86_64 # installs an x86_64 `node.napi.node`
  depends_on "node"

  on_macos do
    depends_on "terminal-notifier"
  end

  conflicts_with "bit-git", because: "both install `bit` binaries"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink libexec.glob("bin/*")

    # Remove vendored pre-built binary `terminal-notifier`
    node_notifier_vendor_dir = libexec/"lib/node_modules/bit-bin/node_modules/node-notifier/vendor"
    node_notifier_vendor_dir.rmtree # remove vendored pre-built binaries

    if OS.mac?
      terminal_notifier_dir = node_notifier_vendor_dir/"mac.noindex"
      terminal_notifier_dir.mkpath

      # replace vendored `terminal-notifier` with our own
      terminal_notifier_app = Formula["terminal-notifier"].opt_prefix/"terminal-notifier.app"
      ln_sf terminal_notifier_app.relative_path_from(terminal_notifier_dir), terminal_notifier_dir
    end

    # Replace universal binaries with their native slices.
    deuniversalize_machos
  end

  test do
    (testpath/"Library/Caches/Bit/config/config.json").write <<~EOS
      { "analytics_reporting": false, "error_reporting": false }
    EOS
    output = shell_output("#{bin}/bit init --skip-update")
    assert_match "successfully initialized", output
  end
end
