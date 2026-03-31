class Boogiewoogie < Formula
  desc "Git profile manager for switching between multiple Git identities"
  homepage "https://github.com/malhotra-rishabh/boogiewoogie"
  url "https://github.com/malhotra-rishabh/homebrew-boogiewoogie/archive/refs/tags/v1.0.19.tar.gz"
  sha256 "438398f15fd1e840d289f63d9e036e20c9db99a132cb7283c8dcb1cd059fd2b0"
  license "MIT"
  head "https://github.com/malhotra-rishabh/boogiewoogie.git", branch: "main"
  version "1.0.19"

  livecheck do
    url "https://github.com/malhotra-rishabh/homebrew-boogiewoogie/archive/refs/tags/v1.0.19.tar.gz"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  uses_from_macos "git"
  uses_from_macos "openssh"

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
    system "#{bin}/boogiewoogie", "--version "1.0.19"
    
    # Test profile creation
    ENV["HOME"] = testpath
    system "#{bin}/boogiewoogie", "help"
    
    # Check if config directory is created
    assert_predicate testpath/".boogiewoogie", :exist?
  end
end 