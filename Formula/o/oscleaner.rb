# typed: false
# frozen_string_literal: true

class Oscleaner < Formula
  desc "Cross-platform system cleanup CLI"
  homepage "https://github.com/hebertcisco/oscleaner"
  url "https://github.com/hebertcisco/oscleaner/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "99152dfe90659e4ecda0bee8ab822f5b21401be7eb9a24cad12fe0c8cb1541d6"
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
