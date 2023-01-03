require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-15.0.0.tgz"
  sha256 "80ae205e63bdf087f7f6fdc79066590d001a39971cb7ab63995d8b0d7bdc4ef3"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_ventura:  "f9a79f79054166c7b834458bfbb56c970cc779756cd8ad3763c1a87298932cf7"
    sha256                               arm64_monterey: "92e63aa56997648294dc45979b79e951cb6604adad553b869bfe26d904326600"
    sha256                               arm64_big_sur:  "fcb8acccfd93fdc5efcc6964f505c6a51281d72a4df3f40e4440c1d0cb46af9e"
    sha256                               ventura:        "7414634945853b554539e649de8b93d4c4b99e2d891e2231af868d4c9b982461"
    sha256                               monterey:       "f90736e2afb2ce6fd189389ab41d5763002e8ba8977e47069a1b469c255c1c60"
    sha256                               big_sur:        "862c8d597daf06fd071f8c16d5b46b36e3ce40271152c9fbf6d479e756f37d44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ce5eaf2224409a86b08f4277f6b3ca4c10a97d6591d86cd8914584c88b5a463"
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
