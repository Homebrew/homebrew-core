require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-18.2.4.tgz"
  sha256 "a0133ffd0c47ad31d3c3f251344fb4f379b0848dc9e56435855e51cbc6ba5d68"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_sonoma:   "4896f2c7bbd35aaf1e8a14218d4217f410d8f967a904684a7dbd3d715752a742"
    sha256                               arm64_ventura:  "4334205ded7745967006f413d2ee6b3e747a5153c897289e3386472ccb028dc2"
    sha256                               arm64_monterey: "32e281d359bdbd04a5b21975f4d6b130039d9800e161a26c5bc85ae02de060e1"
    sha256                               sonoma:         "43abab50e603f984574671487f58594a4236cccd21d3d3f7c6ba991d334b026d"
    sha256                               ventura:        "97ec324ee819207dfa1a73fc3731ed2b597995092ca86f9c0dd933cda7597b65"
    sha256                               monterey:       "df4ed0f49a6782870459819636b6ec514e3c5aa1855198cf2e89cfccffce10e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5770414478ceff5119f06c55a7d1a3ec4b4f38f974c8442ffe3f01abfc6a5feb"
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
