class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-11.1.1.tgz"
  sha256 "29ec267ed58a25116cc45fe98ac875f8b483c5bb6f252c330739f4aee1f96dda"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ab023680ad3fdee155e5dd3eeda9d89694487fe177613ad082a6f095fe30b318"
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
