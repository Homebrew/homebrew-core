class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://bit.dev"
  url "https://registry.npmjs.org/bit-bin/-/bit-bin-14.8.8.tgz"
  sha256 "25d899bacd06d77fad41026a9b19cbe94c8fb986f5fe59ead7ccec9f60fd0ef9"
  license "Apache-2.0"
  revision 1
  head "https://github.com/teambit/bit.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256                               arm64_tahoe:    "82201904fa2ec0416232bc8e3fa85b60945f07b58dbfa69566c800c96947fb7f"
    sha256                               arm64_sequoia:  "591d452238af32826df679aa962d6ce755294473c450bc5118dfac9e50a552f8"
    sha256                               arm64_sonoma:   "b69b3a7ba901fd29b6ef35d47b7248a4219b55336ad1cf04dd2f5cd8268387b8"
    sha256                               arm64_ventura:  "37e5de52910eb4d93ff0d8c1d4348b8d1131b691af23ec0db82be76ba32a6417"
    sha256                               arm64_monterey: "47b532eb0b388e861e2da67c40cf213d4795277c4f7be59cc949fbac656d0e5f"
    sha256                               sonoma:         "a5b469dc4bfc6937d12296c2c768b9dc3a210c8a9e1fe796213823b7ecd68c19"
    sha256                               ventura:        "cbfe314c2c994b80648167a54ecca3cc3fb09c8824ef88f274d935d98ba8aafd"
    sha256                               monterey:       "57c91e19fbc60897fa432f7028898f75d47395239fce208cb9222f83f78a1ac5"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "e0b88da3686ca8ece21a232981d3d40196d0f4b1f8c9aabb55d2f4be142e33e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d998d44c9e7d076515e9363153c1aeaa4c8ddee77f9554152f6af2fab077764"
  end

  depends_on "node"

  on_macos do
    depends_on "terminal-notifier"
  end

  conflicts_with "bit-git", because: "both install `bit` binaries"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/bit-bin/node_modules"
    (node_modules/"leveldown/prebuilds/linux-x64/node.napi.musl.node").unlink
    (node_modules/"leveldown/prebuilds").each_child { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

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
  end

  test do
    (testpath/"Library/Caches/Bit/config/config.json").write <<~JSON
      { "analytics_reporting": false, "error_reporting": false }
    JSON
    output = shell_output("#{bin}/bit init --skip-update")
    assert_match "successfully initialized", output
  end
end
