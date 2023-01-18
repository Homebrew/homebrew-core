require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-15.0.3.tgz"
  sha256 "a8defbfe9f1cbc08841c52286321c1a6d0043da8c6063e330082f2e87621c4e9"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_ventura:  "41ce6103016c1f622b7fe968e2f1009e1cd4f973c08b883a5c6193cb7b8e2e5c"
    sha256                               arm64_monterey: "936bbd8f1c0c45c265ad1f211e9928e41bbbd975572408ef01346c5c03fe4a60"
    sha256                               arm64_big_sur:  "ffe64b4eea66ebfba46a6316f062882404f97b5669d77a45cdc7cb9210595ee7"
    sha256                               ventura:        "b9749d912b2ce87263aff6f0a2ed99e5e774ce5d526df13dbae42bf0d568ce5c"
    sha256                               monterey:       "46cda49441d8ea87c06a84096a9bc6e1b36373fac438e5637fc1618afdbd5a0d"
    sha256                               big_sur:        "25e94eb767a9a1d441fa4bd31f185040a7a35a69b6c8ecce52ed2eef9181d4f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90cdf0df4bc0a568520b015230f628e400cf04a9d41f6872609f5f89b78450d1"
  end

  depends_on "node@14"

  on_macos do
    depends_on "macos-term-size"
  end

  def install
    ENV.deparallelize
    system Formula["node@14"].opt_bin/"npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin/"balena").write_env_script libexec/"bin/balena", PATH: "#{Formula["node@14"].opt_bin}:${PATH}"

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
