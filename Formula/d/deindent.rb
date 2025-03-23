class Deindent < Formula
  desc "Command-line utility to format overly-indented text"
  homepage "https://github.com/adriangoransson/deindent"
  url "https://github.com/adriangoransson/deindent/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "92fac2d1920f081aff8b2047d68edccc505493fdd367029b2a7b8b507ae267f6"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "Open3"

    # Indented with <<-
    input = <<-TEXT
      This is a multiline
      string in Ruby.

      Pretty clean, right?
    TEXT

    # Deindented with <<~
    expected = <<~TEXT
      This is a multiline
      string in Ruby.

      Pretty clean, right?
    TEXT

    Open3.popen2("deindent") do |stdin, stdout|
      stdin.write input
      stdin.close
      assert_match expected, stdout.read
    end
  end
end
