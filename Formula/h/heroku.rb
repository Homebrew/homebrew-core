class Heroku < Formula
  desc "CLI for Heroku"
  homepage "https://www.npmjs.com/package/heroku/"
  url "https://registry.npmjs.org/heroku/-/heroku-11.3.0.tgz"
  sha256 "700860a8659627439991e7034c5ad2d818cc85dbbba715247348477cfc3540e8"
  license "ISC"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "713259649ce31398ccfb044284df20418c33875752f9334cbe0beabe7e8dfec6"
    sha256 cellar: :any,                 arm64_sequoia: "a2e2a1c35d2a8652f7095a986835867f088dd4618d93ea28b56dfa6efe044613"
    sha256 cellar: :any,                 arm64_sonoma:  "a2e2a1c35d2a8652f7095a986835867f088dd4618d93ea28b56dfa6efe044613"
    sha256 cellar: :any,                 sonoma:        "c82cd063288270117a806a76849680a5102a4293d263036f2eafcf226a4c8ec7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "182cd65b876a13c36f89b4a077217a29e7d50418f9a132847d54eefc4eb75433"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91b3db631865127bff85542f96722680ddbde3d512354225eda27c13ccfb9599"
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

    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

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
