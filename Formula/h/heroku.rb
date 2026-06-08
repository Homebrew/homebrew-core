class Heroku < Formula
  desc "CLI for Heroku"
  homepage "https://www.npmjs.com/package/heroku/"
  url "https://registry.npmjs.org/heroku/-/heroku-11.4.0.tgz"
  sha256 "fc8b6d466a90bef772b629398145a128ec8e3cd49f14c9da9e0ab485355c9e51"
  license "ISC"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "59b3a82e869291193daf35bfe94fc9c3a90f85ac4035aae1695a5cecde7b5cf8"
    sha256 cellar: :any,                 arm64_sequoia: "5b620c0b254c5a04b5d163ebc63a9377c2a2f9b1a5aa082c683c519c8f85193a"
    sha256 cellar: :any,                 arm64_sonoma:  "5b620c0b254c5a04b5d163ebc63a9377c2a2f9b1a5aa082c683c519c8f85193a"
    sha256 cellar: :any,                 sonoma:        "f143b3ec19b201b3950417ce7884e3215d6886afd474b98005373d2c724c11dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9ed7338c5a182bbf7c8f3795f9ad043aeea9529ffbfad776341013ffe9a9971"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7940431f15ccbd011a5055bc04e82fe480e1871c41c8cf730cc547372f50a867"
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
