class Flyline < Formula
  desc "Supercharged Bash plugin replacement for readline"
  homepage "https://github.com/HalFrgrd/flyline"
  url "https://github.com/HalFrgrd/flyline/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "7d0af846bbfaa48f4ebe3c78f24135f3a6298990cd98903c39601be89e510b71"
  license any_of: ["GPL-3.0-only", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "92a3756f03f9fcd9d41aab5f16ad91945443f362395c9a2b2fc726a1fcc80fc8"
    sha256 cellar: :any, arm64_tahoe:       "75de40255ac59ed6a4649f140dcff614236be4cb94514661f24998343495eb4f"
    sha256 cellar: :any, arm64_sequoia:     "c5d1e2fc2bd8022e4c1bb6d849081487ed5c6dc1061bba5a40a6fdf6b8b2ee8d"
    sha256 cellar: :any, arm64_linux:       "8b54037d9f84e4d34a7662f9f4bc393de213acb1352805108e3eb4f32279d0ef"
    sha256 cellar: :any, x86_64_linux:      "869128ed7daf1c671c93952a0bf7a6d8cbec66a472eadec1ed46b89e7624bb6a"
  end

  depends_on "rust" => :build
  depends_on "bash" => :test

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
