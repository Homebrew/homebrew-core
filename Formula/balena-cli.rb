require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  # balena-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-14.3.0.tgz"
  sha256 "6b9ce0c55fa56d68c3aa41ceff1a0de41779ff5fa7794a34bb010c5166f69e82"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_monterey: "88bf5472be1e1b7d75e9bd8f93e9113ad9784203fdb3ee4d3b559cb068e63c8d"
    sha256                               arm64_big_sur:  "744c93680d8998a0f8aa91a9d2db4e8effbaaa21939adca019b897c8c56a4578"
    sha256                               monterey:       "781f6265b8c5ba70f1413ebe2ac4f605536b1bff0c94a32d681afa3fa201c8e8"
    sha256                               big_sur:        "814f170afb2517ba02d38727c3e6491923deaacffe2c49ae0aba65fa08978783"
    sha256                               catalina:       "a22bb47f78c37ec381c37fd3c076afada45fba0971fe3add96ac5eb0a5a72f2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "edb479e8609817b1eb8beb527e0a323fe50549fd3a9bf8302dc7152674b1bbe0"
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
