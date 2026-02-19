class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-13.4.0.tgz"
  sha256 "553b5fc4add54bedcc93280ec6f9ada765854455d778fe583f0bdc424a5ba37b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27f31038d6e0526c6cd9f7116bbdd0c2efb4b1b24f5ef41e8e8ad64ee46310cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e72887c413f97896410723a528a35477bcef2071a71b8f68a6fd66e880b9576"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e72887c413f97896410723a528a35477bcef2071a71b8f68a6fd66e880b9576"
    sha256 cellar: :any_skip_relocation, sonoma:        "b90208b925ce2ace081ad64620f5f1b629d44fb6c3ce54429b1cb23cf0130152"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "181dc82869e34bac1dae06ce253a09609e97a9842d7aa25e47053c54a767aaf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "181dc82869e34bac1dae06ce253a09609e97a9842d7aa25e47053c54a767aaf7"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/appwrite-cli/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    output = shell_output("#{bin}/appwrite client --endpoint http://localhost/v1 2>&1", 1)
    assert_match "Error: Invalid endpoint", output

    assert_match version.to_s, shell_output("#{bin}/appwrite --version")
  end
end
