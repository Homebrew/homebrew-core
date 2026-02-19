class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-15.6.0.tgz"
  sha256 "496519ddf8c8c10b2987ad2abcc3b1ffd3dbf9a0095c53eed7b207cac3d79c42"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5b760cb12797cabf1dc37610c278fa586afbd2fb6b96f3ddda375ed49dd719e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "929de85376b3324f29631e7cacdc4bfa821f4543fb72c694a7f3dbbcf79f4e5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "929de85376b3324f29631e7cacdc4bfa821f4543fb72c694a7f3dbbcf79f4e5e"
    sha256 cellar: :any_skip_relocation, sonoma:        "56a6b296d1f74530b01a4054e3383d72d40ee63d759e89a4a17b8fa781c0c9a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ab1102c804e451ba7992e55f97fc65fda6550a97f3fefe4d0eac5f45d307d21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ab1102c804e451ba7992e55f97fc65fda6550a97f3fefe4d0eac5f45d307d21"
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
