# Formula for DevSweep
# To test locally:
#   brew install --build-from-source ./devsweep.rb
# To publish to Homebrew Core:
#   1. Create a GitHub release with a tarball
#   2. Update the url and sha256 below with the release URL
#   3. Test locally with: brew install --build-from-source ./devsweep.rb
#   4. Run: brew audit --strict --online ./devsweep.rb
#   5. Submit PR to Homebrew/homebrew-core

class Devsweep < Formula
  desc "Intelligent macOS developer cache cleaner"
  homepage "https://github.com/Sstark97/dev_sweep"
  url "https://github.com/Sstark97/dev_sweep/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "627b33cfc8e360584858d2b0cac4ec09e23dae71c847aa5997c0b67c3e661a21"
  license "MIT"
  head "https://github.com/Sstark97/dev_sweep.git", branch: "main"

  depends_on "bash" => :build

  def install
    # Install all source files
    prefix.install "src"
    prefix.install "bin"
    
    # Create executable
    bin.install_symlink prefix/"bin/devsweep"
  end

  test do
    system "#{bin}/devsweep", "--version"
    system "#{bin}/devsweep", "--dry-run", "--jetbrains"
  end
end
