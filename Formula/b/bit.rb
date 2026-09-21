class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://bit.dev"
  url "https://registry.npmjs.org/bit-bin/-/bit-bin-14.8.8.tgz"
  sha256 "25d899bacd06d77fad41026a9b19cbe94c8fb986f5fe59ead7ccec9f60fd0ef9"
  license "Apache-2.0"
  revision 1
  head "https://github.com/teambit/bit.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "05ca9828a0854f2524ed1e74551c7a767d4be7ce742c5d6b4a208c2879bfe2b9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "05ca9828a0854f2524ed1e74551c7a767d4be7ce742c5d6b4a208c2879bfe2b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "05ca9828a0854f2524ed1e74551c7a767d4be7ce742c5d6b4a208c2879bfe2b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1cc4d6b68d102e7b498e32b58c13c7ade59c081f9df581304c3cfb4b88e96e59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "3d483b7235678b0143df74d0819f144eb673e4a1cc2dd66edaf1632c68cc4b57"
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

    return unless OS.mac?

    terminal_notifier_dir = node_notifier_vendor_dir/"mac.noindex"
    terminal_notifier_dir.mkpath

    # replace vendored `terminal-notifier` with our own
    terminal_notifier_app = formula_opt_prefix("terminal-notifier")/"terminal-notifier.app"
    ln_sf terminal_notifier_app.relative_path_from(terminal_notifier_dir), terminal_notifier_dir

    deuniversalize_machos node_modules/"fsevents/fsevents.node"
  end

  test do
    (testpath/"Library/Caches/Bit/config/config.json").write <<~JSON
      { "analytics_reporting": false, "error_reporting": false }
    JSON
    output = shell_output("#{bin}/bit init --skip-update")
    assert_match "successfully initialized", output
  end
end
