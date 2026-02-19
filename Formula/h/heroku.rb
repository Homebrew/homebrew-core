class Heroku < Formula
  desc "CLI for Heroku"
  homepage "https://www.npmjs.com/package/heroku/"
  url "https://registry.npmjs.org/heroku/-/heroku-10.17.0.tgz"
  sha256 "a443d816a7d52aa58751c7a1a95406a83a58d88860e554b2b3d796e08e5a4ccf"
  license "ISC"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cece3dc3c9e75ee4a711840477ba3afcafb6cf544f39c9154135adba21aa9e94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e17a624159786289b4b70ff5e8a2652d1aacc4b6181dd3488fba38f72f5263fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e17a624159786289b4b70ff5e8a2652d1aacc4b6181dd3488fba38f72f5263fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d6dcefab89d672b0f76cee52a80b06fd2051af44a974ba6c035acc72c64a162"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27239143925a4bf8e29e2ce55489f1210118b374f3bd5879cce80c1a98c99ee5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27239143925a4bf8e29e2ce55489f1210118b374f3bd5879cce80c1a98c99ee5"
  end

  depends_on "node"

  on_macos do
    depends_on "terminal-notifier"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/heroku/node_modules"
    # Remove vendored pre-built binary `terminal-notifier`
    node_notifier_vendor_dir = node_modules/"node-notifier/vendor"
    rm_r(node_notifier_vendor_dir) # remove vendored pre-built binaries

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
    assert_match "Error: not logged in", shell_output("#{bin}/heroku auth:whoami 2>&1", 100)
  end
end
