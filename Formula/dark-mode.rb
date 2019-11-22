class DarkMode < Formula
  desc "Control the macOS dark mode from the command-line"
  homepage "https://github.com/sindresorhus/dark-mode"
  url "https://github.com/sindresorhus/dark-mode/archive/v3.0.0.tar.gz"
  sha256 "c79eb0a96e179953a12f69ec3486b2d89751599c5f5e3cf72ff4def7fd49dcbb"
  head "https://github.com/sindresorhus/dark-mode.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "731a265bb76b143c30f3b6813973f3cfeee3be84b0020c9a616e3f9da326ec26" => :catalina
    sha256 "45e08014f007e1e35fe9bd4619f3ec7517f06d5a5b9869412ae629dbc5010085" => :mojave
  end

  depends_on :xcode => :build
  depends_on :macos => :mojave

  def install
    system "./build"
    bin.install "bin/dark-mode"
  end

  test do
    system "#{bin}/dark-mode", "--version"
  end
end
