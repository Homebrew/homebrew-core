class Heroku < Formula
  desc "CLI for Heroku"
  homepage "https://www.npmjs.com/package/heroku/"
  url "https://registry.npmjs.org/heroku/-/heroku-11.13.0.tgz"
  sha256 "401e22e1f0ffd3c9e42ad6ac0c54d5ef97f310e1da5110b76935be7b9cc217db"
  license "ISC"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6c7e1f2b665563cfcd3d0536d1b0d3ba9dbd9da0504c710c2cac98f8ab04c7bd"
    sha256 cellar: :any, arm64_tahoe:       "6c7e1f2b665563cfcd3d0536d1b0d3ba9dbd9da0504c710c2cac98f8ab04c7bd"
    sha256 cellar: :any, arm64_sequoia:     "6c7e1f2b665563cfcd3d0536d1b0d3ba9dbd9da0504c710c2cac98f8ab04c7bd"
    sha256 cellar: :any, arm64_linux:       "9ee0c8e5deff2a4bed411fa9efabcb1843c97bf4e0fe717a7b2bdb8abbcf2575"
    sha256 cellar: :any, x86_64_linux:      "d71a5af99ef7b8e49f31c44e6de0ad3fb0061be3a6007c265b1ccbd3370a2fa2"
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
    node_modules.glob("{bare-buffer,bare-fs,bare-path,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    # Replace universal binaries with their native slices.
    deuniversalize_machos
  end

  test do
    assert_match "Error: not logged in", shell_output("#{bin}/heroku auth:whoami 2>&1", 100)
  end
end
