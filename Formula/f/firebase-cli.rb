class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-15.3.1.tgz"
  sha256 "055454edf0e3927aee5b702616ca27cb1bedae281320cb267d3cf428c32a6d89"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b8af0e0bc364a21100855d0f120fbe488b46e8003645e8389553de810d9b7cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15f012a10744cda428a6cccf0eb2cd56f5099f8a164afb094b1fc3a47e9883fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15f012a10744cda428a6cccf0eb2cd56f5099f8a164afb094b1fc3a47e9883fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee4bc3ba9c694d47e4cf579844c5702725bbfbc579a404e252c306e97219fdd5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8344fb0960ea5d947bdc0db47fe041243bafb3ee68b41670017ba2b84f2914d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8344fb0960ea5d947bdc0db47fe041243bafb3ee68b41670017ba2b84f2914d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/firebase-tools/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/firebase --version")

    assert_match "Failed to authenticate", shell_output("#{bin}/firebase projects:list", 1)
  end
end
