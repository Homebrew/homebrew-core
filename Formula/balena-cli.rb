require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-14.5.12.tgz"
  sha256 "a0816d9ba1755115ba6ceab6d842b0e6c9ccdffc5d27e7f1c46600d9f7b57dec"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_ventura:  "300d6ea7b3adc8310edd5190d2651a04791b93f91ce1ac4f39de382dffd16e53"
    sha256                               arm64_monterey: "f9b6e53ecbc2be8b0705620b7f5855b7ff47272b5ba9b4c5b344681ace1e1f1d"
    sha256                               arm64_big_sur:  "27cf91171cde932b173d0c6af302da30ad42dc6bba52dc77374491ee026eac5c"
    sha256                               ventura:        "6e8ba3377958853c5ea29fbc9f635ecc9bd1044b6d248fe33b193383925ef8f2"
    sha256                               monterey:       "c152aeaf18cff1d23631c8781c96f5dd5235000f6cb2b5f634a227f4ff80967f"
    sha256                               big_sur:        "e25d08517b71903ed8d9dba8cc49753797488ef6b956d82d1739d5265b7ca788"
    sha256                               catalina:       "f1012ebae09296806d384ef3ab53f429dd77272f752caa6def67a9a8bc5a1f60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2b01f4a61a7fa183c95fd8d09ffe7035303f9c7e370e2fe30cadd288ef27e2b"
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
