class Flyline < Formula
  desc "Supercharged Bash plugin replacement for readline"
  homepage "https://github.com/HalFrgrd/flyline"
  url "https://github.com/HalFrgrd/flyline/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "067b68de0d1484a43fb77124fd2544f19b3ee30691635d038e94f13868ddb27f"
  license any_of: ["GPL-3.0-only", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "91824b0b1b3d8b8440b786c247e10b0ff01fde10f559e5bb82ca0479d933cdde"
    sha256 cellar: :any, arm64_sequoia: "be1a1fc6f9eb4d39e6dd4423ead18d0294f9717ad400770d7179f817ee97f87a"
    sha256 cellar: :any, arm64_sonoma:  "4688a1533e787fb91d872166a6868db4bb153fc588939991b0bc8cd6ec40f740"
    sha256 cellar: :any, sonoma:        "f4e47f5d7fd54008c4d50e8eebef191d211c5d0ad21999903e565f711d989cfa"
    sha256 cellar: :any, arm64_linux:   "560de5fb5cfb0e56b06ecc025d1c9fbbc8f54a4f3f214b0d741e52eb9ea34837"
    sha256 cellar: :any, x86_64_linux:  "82c49527c52d80a8d26e303e7192eeb3d4e6cfdf1ee7c1f7caca00f1e0053fd4"
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
