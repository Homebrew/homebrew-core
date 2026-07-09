class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-22.4.0.tgz"
  sha256 "0e47a437bce36ce4badd0c74204098793ab9892459e3ea3e2e51cf4b3053916f"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1de1ec5ddfd63cb8ff49223e33d43ac013d7e1caee3c8ea46e2f21368d51e6eb"
    sha256 cellar: :any,                 arm64_sequoia: "07c9d1ff625da2cff4277cbef965b62919a11b7a0c07a73ca927f720ef953599"
    sha256 cellar: :any,                 arm64_sonoma:  "07c9d1ff625da2cff4277cbef965b62919a11b7a0c07a73ca927f720ef953599"
    sha256 cellar: :any,                 sonoma:        "0d38a6153db4d340a92ba78b052a89cc26c80f1b18168808eac1d63f96e2ea31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64cefb4424486e3c1fcd39212c0c6e689e87671440991966c5ce302d4ea18bf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "488b927820650ecc2f8edf7ccce141636c582e7abcaf662ce2d01846addc250f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/appwrite-cli/node_modules"
    machos = %w[fsevents/fsevents.node app-path/main]
    machos.each { |macho| deuniversalize_machos node_modules/macho } if OS.mac?
  end

  test do
    output = shell_output("#{bin}/appwrite client --endpoint http://localhost/v1 2>&1", 1)
    assert_match "Error: Invalid endpoint", output

    assert_match version.to_s, shell_output("#{bin}/appwrite --version")
  end
end
