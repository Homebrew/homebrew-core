class LaravelMissingTranslations < Formula
  desc "CLI tool to find missing translation keys in Laravel projects"
  homepage "https://github.com/OthmanHaba/laravel-missing-translations"
  version "1.0.0"
  license "MIT"

  on_macos do
    on_intel do
      url "https://github.com/OthmanHaba/laravel-missing-translations/releases/download/v#{version}/laravel-missing-translations-darwin-amd64.tar.gz"
      sha256 "d7c99e0e4252af094ac1a15f454bd7131ff19ae411122f353a0ba007ec1a0035"
    end
    on_arm do
      url "https://github.com/OthmanHaba/laravel-missing-translations/releases/download/v#{version}/laravel-missing-translations-darwin-arm64.tar.gz"
      sha256 "63195a1c87f43d11f2a22401053fd1ed4d3165da25094708008c38afb17488e0"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/OthmanHaba/laravel-missing-translations/releases/download/v#{version}/laravel-missing-translations-linux-amd64.tar.gz"
      sha256 "d7c99e0e4252af094ac1a15f454bd7131ff19ae411122f353a0ba007ec1a0035"
    end
    on_arm do
      url "https://github.com/OthmanHaba/laravel-missing-translations/releases/download/v#{version}/laravel-missing-translations-linux-arm64.tar.gz"
      sha256 "63195a1c87f43d11f2a22401053fd1ed4d3165da25094708008c38afb17488e0"
    end
  end

  def install
    if OS.mac?
      if Hardware::CPU.arm?
        bin.install "laravel-missing-translations-darwin-arm64" => "laravel-missing-translations"
      else
        bin.install "laravel-missing-translations-darwin-amd64" => "laravel-missing-translations"
      end
    elsif OS.linux?
      if Hardware::CPU.arm?
        bin.install "laravel-missing-translations-linux-arm64" => "laravel-missing-translations"
      else
        bin.install "laravel-missing-translations-linux-amd64" => "laravel-missing-translations"
      end
    end
  end

  test do
    system "#{bin}/laravel-missing-translations", "-h"
  end
end