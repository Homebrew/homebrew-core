# frozen_string_literal: true

class Q < Formula
  desc "Run SQL directly on CSV or TSV files"
  homepage "https://harelba.github.io/q/"
  url "https://github.com/harelba/q/archive/v3.1.6.tar.gz"
  sha256 "e63ba4ae49647f764c5255ad7065d2c614fdf03a2f7349a795de69529701fab8"

  license "GPL-3.0-or-later"

  depends_on "pyoxidizer" => :build
  depends_on "python@3.8" => :build
  depends_on "ronn" => :build
  depends_on xcode: ["12.4", :build]

  def install
    arch_folder = if OS.linux?
      "x86_64-unknown-linux-gnu"
    elsif Hardware::CPU.intel?
      "x86_64-apple-darwin"
    else
      "aarch64-apple-darwin"
    end

    system "pyoxidizer", "build", "--release"
    bin.install "./build/#{arch_folder}/release/install/q"

    system "ronn", "--roff", "--section=1", "doc/USAGE.markdown"
    man1.install "doc/USAGE.1" => "q.1"
  end

  test do
    seq = (1..100).map(&:to_s).join("\n")
    output = pipe_output("#{bin}/q -c 1 'select sum(c1) from -'", seq)
    assert_equal "5050\n", output
  end
end
