require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-14.5.5.tgz"
  sha256 "e90dfce7df627f980ecd00fe95872e909235c4f4e8f324e631f4572cc10b5508"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_monterey: "7de1577e298970db0c067f28fecf1bed65eb4612917081d397e3d6cfa803610d"
    sha256                               arm64_big_sur:  "826219db6251739d8a0de871917f3d8494e7716f25a0b80b75067271e4f06bc9"
    sha256                               monterey:       "036f42fd19df25b278a8e5119ceaf471ff5ad7f200b13c743d9c505f5d0e4013"
    sha256                               big_sur:        "0a24790dec255503e2b0995e905f31f07fe45d3ebbc7fd9858d176adc7a7bc9b"
    sha256                               catalina:       "fd5213a528c6cdd563dcc563dd08867f287c76f1b7a214680fb791131b0acf48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb34b046088e93423067c9038ef5803fbec6d0dc9f248ff67a7380729bb648ff"
  end

  # Node looks for an unversioned `python` at build-time.
  depends_on "python@3.10" => :build
  depends_on "node@14"

  on_macos do
    depends_on "macos-term-size"
  end

  def install
    ENV.deparallelize
    ENV.prepend_path "PATH", Formula["python@3.10"].opt_libexec/"bin"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin/"balena").write_env_script libexec/"bin/balena", PATH: "#{Formula["node@14"].opt_bin}:$PATH"

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/balena-cli/node_modules"
    node_modules.glob("{ffi-napi,ref-napi}/prebuilds/*")
                .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }

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
    assert_match "Logging in to balena-cloud.com",
      shell_output("#{bin}/balena login --credentials --email johndoe@gmail.com --password secret 2>/dev/null", 1)
  end
end
