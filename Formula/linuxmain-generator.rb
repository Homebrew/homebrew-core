class LinuxmainGenerator < Formula
  desc "A shell command to keep SPM project's tests in sync on OSX and Linux."
  homepage "https://github.com/valeriomazzeo/linuxmain-generator"
  url "https://github.com/valeriomazzeo/linuxmain-generator/archive/0.2.0.tar.gz"
  sha256 "84a7a29ef8680426d52591631610b683c853910c49532ad17d7101bd35ed207b"

  def install
    ENV["CC"] = ""
    system "swift", "build", "-c", "release"
    bin.install ".build/release/linuxmain-generator"
  end
  
  test do
    system "#{bin}/linuxmain-generator", "-h"
  end
end
