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
    sha256                               arm64_ventura:  "cbad4484af371344583c48c709b07bfa3fcfbc1a0bc970cd60a6e5f1329243bd"
    sha256                               arm64_monterey: "eedb78d5f2a6599f7c15170a9824688133bb8e39613e03f29b1f61272e40597e"
    sha256                               arm64_big_sur:  "ccf5c81e819291a417550d15e82ca4ea5e4794f092ddf2288e3b8f5e7b9de702"
    sha256                               monterey:       "1056d69a5bff09e8085c5807993a619c13459d97ec5a01b80c136cb2b0a3b633"
    sha256                               big_sur:        "76d7dfff473f81e519d3a59da39eac34f68f6bcc25a4db2d6924cfb8a8032f8e"
    sha256                               catalina:       "5da1cbc73cb5c942a91b6a129131ec8aa5344e96f5a7488b564e413e5cd5a06e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "576a3c95fd535094e87849782f404f6f5e7ade306a2be25d8e539cae63cea502"
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
