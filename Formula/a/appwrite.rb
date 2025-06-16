class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-8.0.1.tgz"
  sha256 "08ceebcc882f579a3f1200aa9ccf74bdf67acb046092b01f6388576a7270e3e0"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b9e0100daed3c3baf0067b7d872bdc42d7ff24965c1444f80d5a4ae39b7fd1df"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Ensure uniform bottles
    inreplace [
      libexec/"lib/node_modules/appwrite-cli/install.sh",
      libexec/"lib/node_modules/appwrite-cli/ldid/Makefile",
      libexec/"lib/node_modules/appwrite-cli/node_modules/jake/Makefile",
    ], "/usr/local", HOMEBREW_PREFIX
  end

  test do
    output = shell_output("#{bin}/appwrite client --endpoint http://localhost/v1 2>&1", 1)
    assert_match "Error: Invalid endpoint", output

    assert_match version.to_s, shell_output("#{bin}/appwrite --version")
  end
end
