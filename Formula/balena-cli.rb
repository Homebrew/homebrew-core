require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-14.5.11.tgz"
  sha256 "ce5816772e21e830f88afc72cadc24fb48967b928b6d5cd8498cb856ea474421"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_ventura:  "c3243d488a2c65c5efb2d8dc826914d0417bf8a9eb8b600bcd83a9583f6101e8"
    sha256                               arm64_monterey: "f97da39ccceabbc6f096d0bdb7846c111c594c3bd7786690d33ec671353cff93"
    sha256                               arm64_big_sur:  "a6fc3f35780c666d5587810954c96eba01b044e472c5d791ed0eda5ef724dbbb"
    sha256                               monterey:       "2f8ca44748e5a620fbdb2cadf9e4130b6dc9f83bbca46ed897db6ef3d7bb61d2"
    sha256                               big_sur:        "2cd667dea807b91155944fa4c31b8efc500ecb5449db04b07e4465e5b4617421"
    sha256                               catalina:       "42eaa28bcb6b4f32dce63d4dc8d4bb72dc62bfbbd168f0085d702867473cfd81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85fcc997888153def9515ba42540c5ace56b98f63d3e90190dd820e43086b393"
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
