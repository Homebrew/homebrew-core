require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-18.0.1.tgz"
  sha256 "98964bbb00e3066678b5b9fad8d9f640f44cb4232268fea3141cfd8cfd8d15a1"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_sonoma:   "fb5dcb02c339cfa5c9e6bf22c76b0e73c819703dbb56d0e39c77e6b2660065b4"
    sha256                               arm64_ventura:  "5798f8dabbcdc2a991a4f03c70624677b7cdc4de506b58830602e2450cb2cfb0"
    sha256                               arm64_monterey: "6770412cbb1704d50724b1080b4b51ab048d7515191f459f439280952e3e9e37"
    sha256                               sonoma:         "7e56c6a7fca88ddb191485ee3b575ea176cb3945ddcf0fb6a031760f8dda69f6"
    sha256                               ventura:        "86c156e4ffef0dcf1d586d6ccffa31c61b51f2ffb6d3f865884e6b89aac24218"
    sha256                               monterey:       "1b1973ec1898fdac78d9320628aacdcd914811953647a04d5626db63a5810bf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b36c78552b8461b2dceea0bfa9160ae6a01358a436220100f4a7fdd06d55008c"
  end

  # need node@18, and also align with upstream, https://github.com/balena-io/balena-cli/blob/master/.github/actions/publish/action.yml#L21
  depends_on "node@18"

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

    # Replace universal binaries with their native slices.
    deuniversalize_machos
  end

  test do
    ENV.prepend_path "PATH", Formula["node@18"].bin

    assert_match "Logging in to balena-cloud.com",
      shell_output("#{bin}/balena login --credentials --email johndoe@gmail.com --password secret 2>/dev/null", 1)
  end
end
