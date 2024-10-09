class Fortify < Formula
    desc "Fortify is a command-line tool designed to enhance file security through encryption"
    homepage "https://github.com/i3ash/fortify"
    license "MIT"
  
    on_macos do
      if Hardware::CPU.arm?
        url "https://github.com/i3ash/fortify/releases/download/v1.0.10/fortify-darwin-arm64"
        sha256 "d57d9449a6cf96e091f12aaf3395bc163db122bbf426257f93a5e3012ea11911"
      elsif Hardware::CPU.intel?
        url "https://github.com/i3ash/fortify/releases/download/v1.0.10/fortify-darwin-x86_64"
        sha256 "df3e264e62b245867c22efa7bcb9fdd66604dd16f5c3094ead96adf0ee7c7031"
      end
    end
  
    def install
      bin.install "fortify-darwin-arm64" => "fortify" if Hardware::CPU.arm?
      bin.install "fortify-darwin-x86_64" => "fortify" if Hardware::CPU.intel?
    end
  
    test do
      system "#{bin}/fortify", "version"
    end
  end