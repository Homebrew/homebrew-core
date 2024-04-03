# typed: false
# frozen_string_literal: true

class Descope < Formula
  desc "A command line utility for working with the Descope management APIs"
  homepage "https://www.descope..com/"
  version "0.8.2"
  license "MIT"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/descope/cli/releases/download/v0.8.2/descope-v0.8.2-darwin-amd64"
      sha256 "ef60ca82c8fdaec26d9242775a1aee8c7357e401cde20736f2661450262c571c"

      def install
        bin.install "descope-v0.8.2-darwin-amd64" => "descope"
      end
    end
    if Hardware::CPU.arm?
      url "https://github.com/descope/cli/releases/download/v0.8.2/descope-v0.8.2-darwin-arm64"
      sha256 "4545a253db6293c98aea00ebe0f8ab2f3fcb626edc182cef9efe47c1ad10bb2f"

      def install
        bin.install "descope-v0.8.2-darwin-arm64" => "descope"
      end
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/descope/cli/releases/download/v0.8.2/descope-v0.8.2-linux-amd64"
      sha256 "a87367feb7f803469dfd046552ddfe02660ccf0dbdf672b8c20c1adfb0c6f208"

      def install
        bin.install "descope-v0.8.2-linux-amd64" => "descope"
      end
    end
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/descope/cli/releases/download/v0.8.2/descope-v0.8.2-linux-arm64"
      sha256 "aade68ad2adfc6fe625bbffc97c65fae474924b65167260db8d74b987f8f89ce"

      def install
        bin.install "descope-v0.8.2-linux-arm64" => "descope"
      end
    end
  end
end
