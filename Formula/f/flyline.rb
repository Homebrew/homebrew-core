class Flyline < Formula
  desc "Supercharged Bash plugin replacement for readline"
  homepage "https://github.com/HalFrgrd/flyline"
  url "https://github.com/HalFrgrd/flyline/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "cf6984e075286050f03e2b1550290db367cfb249b48d63d2d8e9d5d840e5ae8c"
  license any_of: ["GPL-3.0-only", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d5f7ee032ee2d5cc044f74a6b4c0fa1ae188d2f154cd94906b5264f21d6dc4d1"
    sha256 cellar: :any, arm64_sequoia: "5862c3e09a4b983ad5de8d999d08bfc95ecd489d0cf6c1a721d6b3dcc69876f8"
    sha256 cellar: :any, arm64_sonoma:  "eed1435b29a10ec6808ab721c75e553e229d4a2df0e0a8294b2114c3ad0e67b2"
    sha256 cellar: :any, sonoma:        "cecad69181aeda455ab7a63fbe78a93814abc6ae57354941f73375bdb837aa3a"
    sha256 cellar: :any, arm64_linux:   "8e40c3eb4df3cfab959545df9759389187e4ea27cdca86c349c30397d8f1d614"
    sha256 cellar: :any, x86_64_linux:  "74098069c2c4b3837db7cdfa5ddcc49f714c2ac3c37e7c56b702a5e08ed97cc6"
  end

  depends_on "rust" => :build
  depends_on "bash" => :test

  def install
    cargo_args = std_cargo_args.reject { |arg| arg["--root"] || arg["--path"] }
    system "cargo", "build", "--lib", "--release", *cargo_args
    (lib/"bash").install shared_library("target/release/libflyline") => "flyline"
  end

  test do
    Open3.popen2("script", "-q", "screenlog.txt") do |input, _, thr|
      input.puts "#{formula_opt_bin("bash")}/bash -il"
      sleep 5
      input.puts "stty rows 80 cols 130"
      input.puts "export LC_CTYPE=en_US.UTF-8 LANG=en_US.UTF-8 TERM=xterm"
      input.puts "enable flyline"
      sleep 2
      input.puts "flyline changelog | grep -F 1.3.0"
      sleep 2
      input.puts "exit"
      sleep 5
      input.close
    ensure
      Process.kill("TERM", thr.pid)
    end

    screenlog = (testpath/"screenlog.txt").binread
    # Match the tooltip that should be displayed for the last input line
    assert_match "Display the changelog", screenlog
  end
end
