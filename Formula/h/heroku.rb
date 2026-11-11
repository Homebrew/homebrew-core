class Heroku < Formula
  desc "CLI for Heroku"
  homepage "https://www.npmjs.com/package/heroku/"
  url "https://registry.npmjs.org/heroku/-/heroku-11.13.0.tgz"
  sha256 "401e22e1f0ffd3c9e42ad6ac0c54d5ef97f310e1da5110b76935be7b9cc217db"
  license "ISC"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "57f9c01af20324f3ab28e281d05a0de546accdbc682e73fc0f1601e5cd2d79fc"
    sha256 cellar: :any, arm64_tahoe:       "57f9c01af20324f3ab28e281d05a0de546accdbc682e73fc0f1601e5cd2d79fc"
    sha256 cellar: :any, arm64_sequoia:     "57f9c01af20324f3ab28e281d05a0de546accdbc682e73fc0f1601e5cd2d79fc"
    sha256 cellar: :any, arm64_linux:       "cc522678f4350563de109ff45e6694e7bfdbbab09d1fc5575ba44f6f764f95d9"
    sha256 cellar: :any, x86_64_linux:      "cfac023a5d3d61950e48f13c965e86a62ea079332f2b63988576ddb9d05c2c96"
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
