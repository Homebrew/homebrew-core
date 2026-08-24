class Heroku < Formula
  desc "CLI for Heroku"
  homepage "https://www.npmjs.com/package/heroku/"
  url "https://registry.npmjs.org/heroku/-/heroku-11.10.0.tgz"
  sha256 "2cd32031bb2dd1963ee3d5c7e6970a038d25823eb58c8df6f6ae1491751d7e04"
  license "ISC"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d813b15fb5f9bb674b2b9378be2a09ab2360af39906cd58e7293564caf94f76a"
    sha256 cellar: :any, arm64_sequoia: "d813b15fb5f9bb674b2b9378be2a09ab2360af39906cd58e7293564caf94f76a"
    sha256 cellar: :any, arm64_sonoma:  "d813b15fb5f9bb674b2b9378be2a09ab2360af39906cd58e7293564caf94f76a"
    sha256 cellar: :any, sonoma:        "fbff6239485dc4cddf0e903e8e21bf6c9d6d586fa7603ab3967614d9a7f757c8"
    sha256 cellar: :any, arm64_linux:   "289a859174ac2c5efafc5b240bf80eabbc50f6e5da365ef39ab951e2291d5c0e"
    sha256 cellar: :any, x86_64_linux:  "e3c989090696106a70048c0430ac47733a96672cd1419ae8cf3e73c89a9d404e"
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
