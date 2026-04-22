class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-18.2.0.tgz"
  sha256 "0fd1965754680ab1d42b99d44a182782a0321fa12f5bd9e48e3a4fb84ce2e25f"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d1af412f517404849b1b5785ae760be097bec24f05797308e8eff406bc3693a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c748ec118a6681084595b274e9713b6859777ba6b8479b6b1ad8cc529d4e258"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c748ec118a6681084595b274e9713b6859777ba6b8479b6b1ad8cc529d4e258"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd2e99a223ab15169d671c8f9101abf0d0c1e1f4bd0e23eb43b1db59a61ac948"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e9676d2e281e682fa768955f66541c1c718f090848a4d793f4d663f9697d202"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e9676d2e281e682fa768955f66541c1c718f090848a4d793f4d663f9697d202"
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
