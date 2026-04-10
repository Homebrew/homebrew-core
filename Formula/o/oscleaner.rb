# typed: false
# frozen_string_literal: true

class Oscleaner < Formula
  desc "Cross-platform system cleanup CLI"
  homepage "https://github.com/hebertcisco/oscleaner"
  url "https://github.com/hebertcisco/oscleaner/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "64225eb169a28548602963f3d26f8608c1dc451da41905e5be4e2cb359755ab6"
  license "MIT"
  head "https://github.com/hebertcisco/oscleaner.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "oscleaner", shell_output("#{bin}/oscleaner --help")
  end
end
