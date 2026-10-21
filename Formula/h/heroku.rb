class Heroku < Formula
  desc "CLI for Heroku"
  homepage "https://www.npmjs.com/package/heroku/"
  url "https://registry.npmjs.org/heroku/-/heroku-11.12.0.tgz"
  sha256 "fe6dbf07053470bb575fbb466680466ff08a2eb970255cde6fb6d3c5c0eadfb2"
  license "ISC"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "25f38ca7cf43e65dc810bc954edc2456375be2a3baa9ef8f69f6bcbd9f9775bd"
    sha256 cellar: :any, arm64_tahoe:       "25f38ca7cf43e65dc810bc954edc2456375be2a3baa9ef8f69f6bcbd9f9775bd"
    sha256 cellar: :any, arm64_sequoia:     "25f38ca7cf43e65dc810bc954edc2456375be2a3baa9ef8f69f6bcbd9f9775bd"
    sha256 cellar: :any, arm64_linux:       "70d8569bf5954af1940bf5aaa7de89c4d67cd1af88b1a42b223b7772425b6039"
    sha256 cellar: :any, x86_64_linux:      "865051b65b5168ec584f0e6efe711e6103f9e56c4996269b41f7ce0f74b2541f"
  end

  depends_on "node"

  on_macos do
    depends_on "terminal-notifier"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/heroku/node_modules"

    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-path,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    # Replace universal binaries with their native slices.
    deuniversalize_machos
  end

  test do
    assert_match "Error: not logged in", shell_output("#{bin}/heroku auth:whoami 2>&1", 100)
  end
end
