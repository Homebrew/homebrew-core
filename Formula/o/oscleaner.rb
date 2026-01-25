# typed: false
# frozen_string_literal: true

class Oscleaner < Formula
  desc "Cross-platform system cleanup CLI"
  homepage "https://github.com/hebertcisco/oscleaner"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/hebertcisco/oscleaner/releases/download/v1.0.0/oscleaner-aarch64-apple-darwin.tar.gz"
      sha256 "eeb43070933f075eeadb603959d3c86217c58a67cfd3ea1fd040e622cca41dd8"
    else
      url "https://github.com/hebertcisco/oscleaner/releases/download/v1.0.0/oscleaner-x86_64-apple-darwin.tar.gz"
      sha256 "8f6aa58038b205920a19e48da861b1f9144a316ae4a6c2ebe821447d6b0604b3"
    end
  end

  on_linux do
    url "https://github.com/hebertcisco/oscleaner/releases/download/v1.0.0/oscleaner-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "92dde9669110b674dd1299c307a377145525abd5dfd82b45f4c2342232bedf4d"
  end

  def install
    bin_name = if OS.mac?
      Hardware::CPU.arm? ? "oscleaner-aarch64-apple-darwin" : "oscleaner-x86_64-apple-darwin"
    else
      "oscleaner-x86_64-unknown-linux-gnu"
    end

    bin.install bin_name => "oscleaner"
  end

  test do
    output = shell_output("#{bin}/oscleaner --help")
    assert_match "oscleaner", output
  end
end
