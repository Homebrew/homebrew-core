require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  # balena-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-13.3.0.tgz"
  sha256 "4dd72d585071869354d9fd69753d2ee94f8620d75930da1b1664e7986e93ae04"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_monterey: "e2361d555fd51932c89f181367bc6562a5533b289ba1b52863ad768554145320"
    sha256                               arm64_big_sur:  "1da4ae81bd85c7bccd1cb020d7af1fbed697a3fd1eda5b6208d9bba217419bb2"
    sha256                               monterey:       "4dd6dd5555bb834cc6caa6f72c81df711ce95d8d1b6fafa292f840114cc05df5"
    sha256                               big_sur:        "91b914137dfdabdaf586bd45418e2cfca1872875efa8aff19f3bacb79add8f2b"
    sha256                               catalina:       "bbd6eec46e7b64fcad2d4f8361aa3a6504f4c68388d5f091403f1245674adb0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "407a6b0b8083c6c68929fd4f82cc01c5dbd45bd2d85a36f9b802b527829ea9f1"
  end

  depends_on "node@14"

  on_macos do
    depends_on "macos-term-size"
  end

  def install
    ENV.deparallelize
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
