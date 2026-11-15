class Flyline < Formula
  desc "Supercharged Bash plugin replacement for readline"
  homepage "https://github.com/HalFrgrd/flyline"
  url "https://github.com/HalFrgrd/flyline/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "3da007554eed359ef8a0e05875ac9a3c5d251dbce8f50cdc0e864e72a54b3199"
  license any_of: ["GPL-3.0-only", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "93bd47767356dbd3492610377101d7f5a411c2aff43590d95774f70e606e1617"
    sha256 cellar: :any, arm64_tahoe:       "dc45a5972834640cf5463ae916e9087af0948da2f620a05a512e5fd7917cc0ab"
    sha256 cellar: :any, arm64_sequoia:     "4ce0620e7379b1ddd23986eef8a87a98a13c3392582ac7565d5bf81ea90e7f4b"
    sha256 cellar: :any, arm64_linux:       "c6aab634cd9cbca11a8314f6ba466d81983b35ef06bc40d9bce5dccbed61f010"
    sha256 cellar: :any, x86_64_linux:      "351af2dc3a2f79e4c2170bf77a9fc24bed973e092543922c332c1e9f80613da9"
  end

  depends_on "rust" => :build
  depends_on "bash" => :test

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    cargo_args = std_cargo_args.reject { |arg| arg["--root"] || arg["--path"] }
    system "cargo", "build", "--lib", "--release", *cargo_args
    (lib/"bash").install shared_library("target/release/libflyline") => "flyline"
  end

  test do
    require "io/console"
    require "pty"

    output_log = testpath/"output.log"
    PTY.spawn(formula_opt_bin("bash")/"bash", "--noprofile", "--norc", "-i",
              [:out, :err] => output_log.to_s) do |r, w, pid|
      r.winsize = [80, 130]
      w.puts "enable flyline"
      w.puts "flyline version"
      w.puts "flyline changelog"
      w.puts "exit"
      r.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    ensure
      r.close
      w.close
      Process.wait(pid)
    end

    output = output_log.read
    assert_match "Changelog", output
    assert_match version.to_s, output
  end
end
