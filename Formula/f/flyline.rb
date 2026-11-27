class Flyline < Formula
  desc "Supercharged Bash plugin replacement for readline"
  homepage "https://github.com/HalFrgrd/flyline"
  url "https://github.com/HalFrgrd/flyline/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "c805d6227252d51e1863a9901a34f6b6b157b243cc0ca18651da11aa13f1da7b"
  license any_of: ["GPL-3.0-only", "MIT"]

  bottle do
    manifest_sha256 "084173737dae16b4a75a9267ab87e6ee875e173f6f8add9c1d6eb7bccc3aa25e"
    sha256 cellar: :any, arm64_golden_gate: "710c2860779eed5789e3c8b39ab83a38ff709d516043f508b3e5225997d038f6"
    sha256 cellar: :any, arm64_tahoe:       "ad6eeffce9118e252380f866a4badded648bc54c3f5f1becae77789b2774eedc"
    sha256 cellar: :any, arm64_sequoia:     "a4300e8a536adacec8223ecfcf98f432e3795ddadc076c4eae654b585a20e549"
    sha256 cellar: :any, arm64_linux:       "79f2142d4f45e1c614118d1d327615cc69d55717c9ae8d6ca750b77601b9998c"
    sha256 cellar: :any, x86_64_linux:      "45d99b85669f5821070cd902aa7e8e7d130e27896b4504cd6df9c93ce0c898e2"
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
