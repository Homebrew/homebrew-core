class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-10.0.0.tgz"
  sha256 "65554375e855981e2a5bc078f14f2688513c7509f2fcee528eb68b2d9e93a1e3"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7c8e4204486fc3a5ce237ff272a2e50b3723133800fd5b40a1a96ff0bc4c3dbd"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Ensure uniform bottles
    file = libexec/"lib/node_modules/appwrite-cli/lib/commands/update.js"
    homebrew_check_str = "scriptPath.includes('/opt/homebrew/') || scriptPath.includes('/usr/local/Cellar/')"
    inreplace file do |s|
      s.gsub! "scriptPath.includes('/usr/local/lib/node_modules/')", "scriptPath.includes('/lib/node_modules/')"
      s.gsub! "scriptPath.includes('/opt/homebrew/lib/node_modules/') ||", ""
      s.gsub! homebrew_check_str, "true"
    end
  end

  test do
    output = shell_output("#{bin}/appwrite client --endpoint http://localhost/v1 2>&1", 1)
    assert_match "Error: Invalid endpoint", output

    assert_match version.to_s, shell_output("#{bin}/appwrite --version")
  end
end
