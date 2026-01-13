class Dotkeeper < Formula
  desc "Dotfile management/symlink farm tool"
  homepage "https://github.com/stikypiston/dotkeeper"
  url "https://github.com/StikyPiston/dotkeeper/archive/refs/tags/2025.12.19-a.tar.gz"
  version "2025.12.19-a"
  sha256 "d25ddc2f7e211f648300a4a4a257495a237d3eb0a76df946c54c83f9d76826b8"
  license "MIT"

  uses_from_macos "swift" => :build

  def install
    system "swift", "build", "--configuration", "release", "-Xswiftc", "-static-stdlib"
    bin.install ".build/release/dotkeeper"
  end

  test do
    system bin/"dotkeeper"
  end
end
