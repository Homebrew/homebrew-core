class Heroku < Formula
  desc "CLI for Heroku"
  homepage "https://www.npmjs.com/package/heroku/"
  url "https://registry.npmjs.org/heroku/-/heroku-11.14.0.tgz"
  sha256 "1bde73d790d577b6bee8dbdddb755ac084f5357c23d06a86a688c016f9279b78"
  license "ISC"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6956cafe8628c9267139215927b8a63a1beb83f3f616535b80b27a1d9ad44d84"
    sha256 cellar: :any, arm64_tahoe:       "6956cafe8628c9267139215927b8a63a1beb83f3f616535b80b27a1d9ad44d84"
    sha256 cellar: :any, arm64_sequoia:     "6956cafe8628c9267139215927b8a63a1beb83f3f616535b80b27a1d9ad44d84"
    sha256 cellar: :any, arm64_linux:       "11f25973fa2505d1c970ef19eef71b8d790e10fc38e4a65a257b83dca8b81098"
    sha256 cellar: :any, x86_64_linux:      "da8bfdbdbf2a4f888c0f6cc90a19bc6629aafe8744540ef4633bb1384e96ef40"
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
