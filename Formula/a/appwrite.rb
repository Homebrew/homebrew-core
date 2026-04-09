class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-17.3.1.tgz"
  sha256 "c081dbff08039794b54fccd8bfce867b8b256379b291ca23711275d5a390aba3"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4aa514c6b45c453828e71e7de88cb3a08029cdc963b5bdd91139ec38e60e07ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae4e9d77d4fe53bc0f4632c61c3b2922a638ba293c32e2f6e3ca51627d9afa43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae4e9d77d4fe53bc0f4632c61c3b2922a638ba293c32e2f6e3ca51627d9afa43"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4d6e0d95472049130802c7b353edd465a77c8adafb6779489fdd844a45b4edd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b6b17d37efaf2e42592247c9166384257de32bf3a41d33e878241b961a28d72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b6b17d37efaf2e42592247c9166384257de32bf3a41d33e878241b961a28d72"
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
