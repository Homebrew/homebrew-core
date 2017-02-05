class DarkMode < Formula
  desc "Control the macOS dark mode from the command-line"
  homepage "https://github.com/sindresorhus/dark-mode"
  url "https://github.com/sindresorhus/dark-mode/archive/2.0.1.tar.gz"
  sha256 "edea2a21e550194204bc54fe7f68d32dcc517138ac3b12cb17855e61c3260c68"
  head "https://github.com/sindresorhus/dark-mode.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "50d354de8d7fbfe726895dc44547779a70d43cd252fe16580e35925812061a5e" => :sierra
    sha256 "15ffc6e8d672a7601462f3597b5ca26b7ef5d2ce739ea7afa78e0cad23bee49e" => :el_capitan
    sha256 "f58b190cb89027daaea97e8cdc31bc4f097c51fef33e805751a1aef797871e5f" => :yosemite
  end

  depends_on :macos => :el_capitan
  depends_on :xcode => :build

  def install
    system "./build"
    bin.install "bin/dark-mode"
  end

  test do
    system "#{bin}/dark-mode", "--version"
  end
end
