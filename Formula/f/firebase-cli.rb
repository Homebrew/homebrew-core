class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-14.25.1.tgz"
  sha256 "3c1ee2d358ade9f9c7ee9e283c3c28331d97d71eba5602a44a2d04a6140ef4a6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c73697c1cbc2b65f3661846342993bae5c40e7bbfce72b3a5b49db5c3a19755"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c73697c1cbc2b65f3661846342993bae5c40e7bbfce72b3a5b49db5c3a19755"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c73697c1cbc2b65f3661846342993bae5c40e7bbfce72b3a5b49db5c3a19755"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca5ceae661d5d4dd53b567356fe27087466f196ab62e2c06bdbcb96aa72b20a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9abb61c5667cf65c00adb5a3ba0d249d6ce2a6e1109a640b774259f815a0ceb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0d13fdc963a3b0d1d7443ed7c6913435c59565020a299b6a8fd51b9dee6993c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/firebase --version")

    assert_match "Failed to authenticate", shell_output("#{bin}/firebase projects:list", 1)
  end
end
