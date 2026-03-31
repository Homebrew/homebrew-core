class Boogiewoogie < Formula
  desc "Git profile manager for switching between multiple Git identities"
  homepage "https://github.com/malhotra-rishabh/boogiewoogie"
  url "https://github.com/malhotra-rishabh/homebrew-boogiewoogie/archive/refs/tags/v1.0.18.tar.gz"
  sha256 "4764db5950c401d15bf0778311ec6e0a525d35cf69776b37bc187bb526f27ad0"
  license "MIT"
  head "https://github.com/malhotra-rishabh/boogiewoogie.git", branch: "main"
  version "1.0.18"

  livecheck do
    url "https://github.com/malhotra-rishabh/homebrew-boogiewoogie/archive/refs/tags/v1.0.18.tar.gz"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "git"
  depends_on "openssh"

  def install
    bin.install "boogiewoogie"
    
    # Install shell completions
    generate_completions_from_executable(bin/"boogiewoogie", "completion")
    
    # Install manual page
    man1.install "docs/boogiewoogie.1"
  end

  def post_install
    (var/"boogiewoogie").mkpath
  end

  test do
    system "#{bin}/boogiewoogie", "--version"
    
    # Test profile creation
    ENV["HOME"] = testpath
    system "#{bin}/boogiewoogie", "help"
    
    # Check if config directory is created
    assert_predicate testpath/".boogiewoogie", :exist?
  end
end 