# typed: false
# frozen_string_literal: true

class Goji < Formula
  desc "Lightweight version of Oji text emoticon generator. Rewritten in go"
  homepage "https://github.com/sanriodev/goji"
  url "https://github.com/sanriodev/goji/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "9543a521a9f59fd8fba8b33681ef905122826740c82a78acdedac2dce9b15d3c"
  license "MIT"
  
  depends_on "go" => :build
  
  def install
    system "go", "build", *std_go_args
  end

  test do
    output = shell_output("#{bin}/goji -h")
    assert_match(/Create custom or random text emojis/, output)
    assert_match(/--new/, output)
    assert_match(/--random/, output)
  end
end
