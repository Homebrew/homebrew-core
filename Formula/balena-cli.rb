require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-15.0.1.tgz"
  sha256 "210e6106986a8a566e25d4befb839cd2d40d0f9c173829afbd513071426b2541"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_ventura:  "900dd506548dae893b98fb49a22d917cc10eaf60c53838ee55eb02f4de4a9004"
    sha256                               arm64_monterey: "ec76e0e1f0b7f27555b4e4e26b889b1dcb36a793354df8c87a0bb80e84393469"
    sha256                               arm64_big_sur:  "dae1d7aa6df8871438ede3cb5e5be1f73b7598a2535afc3edeeccda91692b4b0"
    sha256                               ventura:        "60fda480b40b4191ebb9332402c6a01a11fa51f9c665a7ec4d6458516bd5e928"
    sha256                               monterey:       "5c21281955911a811e765ce9a537a35aed8d4c30cd4e81879ff198ae51e757b3"
    sha256                               big_sur:        "fd7e0b79bdde6910c2a1caf34d0001576fb4aef6a035e51b24f9f8f07130608d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "829fc2d121b6f6a719618524ef567669848767d48f0dc37bb4c49c16a76935e0"
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
