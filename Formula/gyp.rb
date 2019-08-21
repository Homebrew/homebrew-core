class Gyp < Formula
  desc "Meta-Build system: a build system that generates other build systems"
  homepage "https://gyp.gsrc.io"
  url "https://chromium.googlesource.com/external/gyp", :using => :git
  version "1.0" # gyp doesn't actually have any published versions.

  depends_on "python"

  def install
    system "python3", "setup.py", "install", "--prefix=#{prefix}", "--single-version-externally-managed", "--record=installed.txt"

    bin.install("gyp")
    bin.install("gyp_main.py") # gyp is a bash script that executes gyp_main.py.
  end

  test do
    system "#{bin}/gyp", "--help"
  end
end
