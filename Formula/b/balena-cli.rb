require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-18.1.5.tgz"
  sha256 "10b1ea119641ab381c37138e63ef3dd6a0b49b1a39e59bca601982bae95df32f"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_sonoma:   "116b396bff6d8f325a99d3860530cb4e7f9d1ab6d0ae2fb5679f202c1160c452"
    sha256                               arm64_ventura:  "afb44984b015baf02b07523cf11002d4f3e84699870cbd39d2051e90e5ac00d0"
    sha256                               arm64_monterey: "571706e7a0219fd6151e61afd715ed5590a9b027423cc92fb1bacf32ac6dec22"
    sha256                               sonoma:         "9346fc18472b532333b32d2d876c4fb41eddc30d985cd8866be16d1abc8851f8"
    sha256                               ventura:        "4dd3aaea2492de48af063013c67af3d820863e91c0750dd8299351e7150189a6"
    sha256                               monterey:       "42b6159d84dd74b7e9835d874bad7eec69fcd9b520288536763f671eb59cbe61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9dcf1c571e9937f2dee6d1d232b867d9b7e7d09ceee85bfa5bb961a9c78677a9"
  end

  # need node@20, and also align with upstream, https://github.com/balena-io/balena-cli/blob/master/.github/actions/publish/action.yml#L21
  depends_on "node@20"

  on_macos do
    depends_on "macos-term-size"
  end

  on_linux do
    depends_on "libusb"
    depends_on "systemd" # for libudev
    depends_on "xz" # for liblzma
  end

  def install
    ENV.deparallelize

    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/balena-cli/node_modules"
    node_modules.glob("{ffi-napi,ref-napi}/prebuilds/*")
                .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }

    (node_modules/"lzma-native/build").rmtree
    (node_modules/"usb").rmtree if OS.linux?

    term_size_vendor_dir = node_modules/"term-size/vendor"
    term_size_vendor_dir.rmtree # remove pre-built binaries

    if OS.mac?
      macos_dir = term_size_vendor_dir/"macos"
      macos_dir.mkpath
      # Replace the vendored pre-built term-size with one we build ourselves
      ln_sf (Formula["macos-term-size"].opt_bin/"term-size").relative_path_from(macos_dir), macos_dir

      unless Hardware::CPU.intel?
        # Replace pre-built x86_64 binaries with native binaries
        %w[denymount macmount].each do |mod|
          (node_modules/mod/"bin"/mod).unlink
          system "make", "-C", node_modules/mod
        end
      end
    end

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    ENV.prepend_path "PATH", Formula["node@20"].bin

    assert_match "Logging in to balena-cloud.com",
      shell_output("#{bin}/balena login --credentials --email johndoe@gmail.com --password secret 2>/dev/null", 1)
  end
end
